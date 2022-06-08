/*
Terraform AWS example
awscli가 설치되어 있고, Access Key, Secret Key가 등록되어 있어야 한다.
*/

######################################################################
# Provisioning
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
    to_port = 5985
    description = "WinRM"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


######################################################################
# Set Up Ubuntu Example Server
######################################################################
# aws_instance는 리소스타입, app_server는 리소스네임
# EC2 instance의 ID는 "aws_instance.app_server"가 됨
resource "aws_instance" "app_server" {
  ami           = var.default_ami
  instance_type = var.instance_type
  # security_groups = [var.sgroup_name] # 기존 등록된 보안그룹도 사용가능하다.
  security_groups = [aws_security_group.sgroup.name]
  tags = var.tags
  key_name = var.key_pair_name

  # remote-exec를 위한 ssh connection 셋업
  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = file(var.private_key_path)
    agent = false
  }
  # 실행된 원격 인스턴스에서 수행할 cli명령어
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait", # cloud-init이 끝날 떄 까지 기다린다. 에러 예방 차원에서 항상 써준다.
      "mkdir test-remote-exec"
    ]
  }
}

######################################################################
#Set Up Windows SQL Server
######################################################################
/*
data "template_file" "initdb" {
  template = file("${path.module}/initdb.tpl")
  vars = {
    user = var.db_user,
    passwd = var.db_passwd,
    port = var.db_port
  }
}
*/

resource "aws_instance" "windows_server" {
  ami = var.windows_ami
  instance_type = var.windows_instance_type
  security_groups = [aws_security_group.sgroup.name, aws_security_group.allow_windows_conn.name]
  tags = var.windows_tags
  key_name = var.key_pair_name
  ##############get_password_data = true

  # remote-exec를 위한 connection 셋업
  connection {
    type = "winrm"
    host = self.public_ip
    user = var.windows_server_user
    private_key = file(var.private_key_path)
    #password = var.windows_server_passwd
    timeout = "3m"
  }

  /*
  # 실행된 원격 인스턴스에서 수행할 cli명령어
  provisioner "remote-exec" {
    inline = [
      #"cloud-init status --wait", # cloud-init이 끝날 떄 까지 기다린다. 에러 예방 차원에서 항상 써준다.
      #"mkdir test-remote-exec"
    ]
  }*/

}
