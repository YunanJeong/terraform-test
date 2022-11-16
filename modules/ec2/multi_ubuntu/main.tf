######################################################################
# Set Up Security Groups
######################################################################
# 접속할 PC 보안그룹등록
resource "aws_security_group" "sgroup"{
  name = "yunan_server_sgroup"
  ingress {
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
  count = var.node_count
  ami             = var.ami
  instance_type   = var.instance_type
  # merge에서 나열 순서대로 Update된다.
  tags            = merge(
                      var.tags,
                      { Name="${var.tags.Name}-${count.index}" },
                    )

  key_name        = var.key_name
  security_groups = [
    aws_security_group.sgroup.name,
  ]
}

#################################################
# Server Commands (초기 구성)
#################################################
resource "null_resource" "server_remote"{
  # remote-exec를 위한 ssh connection 셋업
  count = var.node_count
  connection {
    type        = "ssh"
    host        = aws_instance.server[count.index].public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    agent       = false
  }

  # 실행된 원격 인스턴스에서 수행할 cli명령어
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait", # cloud-init이 끝날 떄 까지 기다린다. 에러 예방 차원에서 항상 써준다.
      "mkdir instance-creation-success",
    ]
  }
}

