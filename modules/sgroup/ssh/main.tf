######################################################################
# Set Up Security Groups
######################################################################
# 보안그룹 생성 or 수정
resource "aws_security_group" "sgroup"{
  name = var.sg_name
  # Inbound Rule 1
  ingress {
    # from, to로 포트 허용 범위를 나타낸다.
    from_port = 22
    to_port = 22
    description = "for ssh connection"
    protocol = "tcp"
    cidr_blocks = var.allowed_list
  }
}

resource "aws_security_group" "allows_all_outbound"{
  name = "allows_all_outbound"
    # Outbound Rule 1 (아래 예시는 outbound를 설정하지 않은것과 같은, 전체 허용 표기법이다.)
  egress{
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


