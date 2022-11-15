######################################################################
# Set Up Security Groups
######################################################################
# 보안그룹 생성 or 수정
resource "aws_security_group" "sgroup"{
  name = var.sg_name
  ingress {
    from_port = var.db_port
    to_port = var.db_port
    description = "db connection"
    protocol = "tcp"
    cidr_blocks = var.allowed_list
  }
}