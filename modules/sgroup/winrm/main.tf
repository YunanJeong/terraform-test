######################################################################
# Set Up Security Groups
######################################################################
# 보안그룹 생성 or 수정
resource "aws_security_group" "sgroup"{
  name = "allow_windows"
  ingress {
    from_port = 3389
    to_port = 3389
    description = "rdp"
    protocol = "tcp"
    cidr_blocks = var.win_allowed_lsit
  }
  ingress {
    from_port = 5985
    to_port = 5986
    description = "WinRM"
    protocol = "tcp"
    cidr_blocks = var.win_allowed_lsit
  }
}