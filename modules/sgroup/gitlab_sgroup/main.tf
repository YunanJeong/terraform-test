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
      "git clone https://${var.git_info.user}:${var.git_info.token}@github.com/YunanJeong/terraform-test.git",
    ]
  }
}
