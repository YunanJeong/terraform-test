/*
Terraform AWS example
awscli가 설치되어 있고, Access Key, Secret Key가 등록되어 있어야 한다.
*/

# provisining
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

# my resource
# aws_instance는 리소스타입, app_server는 리소스네임
# EC2 instance의 ID는 "aws_instance.app_server"가 됨
resource "aws_instance" "app_server" {
  ami           = var.default_ami
  instance_type = var.instance_type
  #security_groups = [aws_security_group.kafka.name]
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
