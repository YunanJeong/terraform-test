/*
Terraform AWS example
awscli가 설치되어 있고, Access Key, Secret Key가 등록되어 있어야 한다.
*/

######################################################################
# Provisioning (없어도 동작 가능. 메타정보를 보다 명시적으로 써주기 위함)
######################################################################
terraform {
  # "terraform registry"에서 제공하는 provider를 찾을 수 있음.
  # "$terraform init" 할 때 여기서 정의된 provider를 다운로드 받음.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 0.14.9"
}

# setup to specified provider
provider "aws" {
  profile = "default"
  region  = "ap-northeast-2" # seoul region
}

######################################################################
# Set Up Security Groups
######################################################################
# 보안그룹 생성 or 수정
resource "aws_security_group" "sgroup"{
  name = var.sgroup_name

  # Inbound Rule 1
  ingress {
    # from, to로 포트 허용 범위를 나타낸다.
    from_port = 22
    to_port = 22
    description = "ssh"
    protocol = "tcp"

    # 허용 소스 IP를 지정한다. cidr_blocks에는 리스트가 할당돼야한다.
    # 리스트에 맞게 보안 rule이 각각 추가된다.
    cidr_blocks = var.cidr_blocks_list
  }

  # Inbound Rule 2
  ingress {
    from_port = var.db_port
    to_port = var.db_port
    description = "db connection"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rule 1 (아래 예시는 설정하지 않은것과 같은, 전체 허용 표기법이다.)
  egress{
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 보안그룹 생성 or 수정
resource "aws_security_group" "allow_windows_conn"{
  name = "allow_windows"
  ingress {
    from_port = 3389
    to_port = 3389
    description = "windows_rdp"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5985
    to_port = 5986
    description = "WinRM"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




#################################################
# Set Up for new security groups in running GitLab Server
#################################################
# My new instance "app_server" have to clone repository from my existing git server instance(ec2).
# But, my git instance doesn't permit new instance.
# So, I must add new security groups to my git instance.

# Point 0. How to make new security groups to permit "app server" created by Terraform.
# Point 1. How to add new security groups to existing & running ec2 instance.
#################################################
# gitlab 인스턴스 (이 테라폼 세션에서 다루지 않는 인스턴스)
data "aws_instance" "instance" {
  instance_id = var.gitlab_instance
}
# GitLab 서버에 추가할 보안그룹 생성
resource "aws_security_group" "gitlab_allows_new_instance"{
  ingress {
    from_port = 443
    to_port = 443
    description = "security group to add to gitlab server"
    protocol = "tcp"
    cidr_blocks = ["${aws_instance.app_server.public_ip}/32"]
  }
}
# GitLab 서버에 보안그룹 추가
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.gitlab_allows_new_instance.id
  network_interface_id = data.aws_instance.instance.network_interface_id
}

#################################################
# null reasource example
#################################################
# Git commands must be executed here(second remote-exec)
# It's because of the terraform execution order by resource dependencies

# Point 2. How to run SECOND remote-exec in the newly created instance "app server"
#################################################
# null_resource 사용 => remote-exec의 명령어 순서 문제를 해결
resource "null_resource" "app_server_code"{

  # 리소스 종속성
  depends_on = [
    aws_network_interface_sg_attachment.sg_attachment  # gitlab서버 보안그룹 추가 후
  ]

  # remote-exec에 사용되는 ssh정보
  connection {
    type = "ssh"
    host = aws_instance.app_server.public_ip
    user = "ubuntu"
    private_key = file(var.private_key_path)
    agent = false
  }

  # 실행된 원격 인스턴스에서 수행할 cli명령어
  provisioner "remote-exec" {
    inline = [
      #"cloud-init status --wait", # cloud-init이 끝날 떄 까지 기다린다.
      "mkdir test_second_remote_exec_by_null_resource",
      "sudo apt update && sudo apt install python-is-python3",
      "sudo sed -i 's/#$nrconf{restart} = '\"'\"'i'\"'\"';/$nrconf{restart} = '\"'\"'a'\"'\"';/g' /etc/needrestart/needrestart.conf", # needrestart가 대화형(interactive)모드로 켜지지 않도록 설정
      "sudo apt install -y python3-pip",
      #"sudo apt -y remove needrestart && sudo apt install -y python3-pip", # needrestart를 그냥 삭제.
      "git clone https://${var.git_info.user}:${var.git_info.token}@github.com/YunanJeong/terraform-test.git",
    ]
  }
}
