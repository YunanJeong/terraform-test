######################################################################
# Set Up Security Groups
######################################################################
resource "aws_security_group" "allows_basic"{
  name = "allows_basic_ubuntu"
  ingress {
    description = "for ssh"
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks # 접속할 PC
    from_port   = 22
    to_port     = 22
  }
  ingress {
    description = "for ping test"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = -1
    to_port     = -1
  }
  egress{
    # 인스턴스에서 외부로 나가는 request 모두 허용. 이를 없애면 유사 IDC환경 테스트 가능.
    # outbound 허용을 안해줘도 인스턴스에서 외부로 나가는 response는 문제없다.
    description = "allows all outbound (apt, ping, ...)"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port   = 0
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
  security_groups = [aws_security_group.allows_basic.name, ]
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

