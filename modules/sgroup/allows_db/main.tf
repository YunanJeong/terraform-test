######################################################################
# Set Up Security Groups
######################################################################

resource "aws_security_group" "allows"{
  name = var.sgroup_name
  ingress {
    from_port = var.db_port
    to_port = var.db_port
    description = "db connection"
    protocol = "tcp"
    cidr_blocks = var.allowed_list
  }
}

