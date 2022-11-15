######################################################################
# Set Up Security Groups
######################################################################
# 보안그룹 생성 or 수정
resource "aws_security_group" "sgroup"{
  name = "yunan_server_sgroup"
  # Inbound Rule 1
  ingress {
    # from, to로 포트 허용 범위를 나타낸다.
    from_port   = 22
    to_port     = 22
    description = "for ssh connection"
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }
}

######################################################################
# server Instance
######################################################################
resource "aws_instance" "server" {
  ami             = var.ami
  instance_type   = var.instance_type
  tags            = var.tags
  key_name        = var.key_name
  security_groups = [aws_security_group.sgroup.name, ]
}


#################################################
# server Commands
#################################################
resource "null_resource" "server_remote"{
  # remote-exec를 위한 ssh connection 셋업
  connection {
    type        = "ssh"
    host        = aws_instance.server.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    agent       = false
  }

  # 실행된 원격 인스턴스에서 수행할 cli명령어
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait", # cloud-init이 끝날 떄 까지 기다린다. 에러 예방 차원에서 항상 써준다.
      "mkdir test-make-instance",
    ]
  }
}

