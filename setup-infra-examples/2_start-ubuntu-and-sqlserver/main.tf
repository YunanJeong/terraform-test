#####################################################
# 다음과 같이 여러 모듈을 가져와 인프라를 구성할 수 있다.
#####################################################
module "ubuntu" {
    source = "../../modules/ec2/ubuntu"
    # Module's Variables
    ami              = var.ubuntu_ami
    instance_type    = var.ubuntu_instance_type
    tags             = var.ubuntu_tags
    key_name         = var.key_name
    private_key_path = var.private_key_path
    ssh_cidr_blocks  = var.work_cidr_blocks
}

module "sqlserver" {
    source = "../../modules/ec2/sqlserver"
    # Module's Variables
    ami              = var.mssql_ami
    instance_type    = var.mssql_instance_type
    tags             = var.mssql_tags

    db_user = var.mssql_db_user
    db_pass = var.mssql_db_pass
    db_port = var.mssql_db_port

    key_name         = var.key_name
    private_key_path = var.private_key_path
    work_cidr_blocks = var.work_cidr_blocks
}

# 새 보안그룹 작성 예시(ubuntu->sqlserver에 ssh접근 허용)
resource "aws_security_group" "allows_ssh_more"{
    name = "allows_ssh_${module.sqlserver.id}"  # module's output
    ingress {
      from_port   = 22
      to_port     = 22
      description = "ssh"
      protocol    = "tcp"
      cidr_blocks = ["${module.ubuntu.public_ip}/32"]  # module's output
    }
}

# 보안그룹을 module 기반으로 작성 예시(ubuntu->sqlserver db접근 허용)
module "sq-sqlserver"{
    source = "../../modules/sgroup/sg-sqlserver"

    sg_name = "allows_db_${module.sqlserver.id}"  # module's output
    allowed_list = ["${module.ubuntu.public_ip}/32"]  # module's output
    # db_port = 1433
}


# 보안그룹을 sqlserver instance에 등록
data "aws_instance" "instance" {
  instance_id = module.sqlserver.id  # module's output
}

resource "aws_network_interface_sg_attachment" "sg_attach_ssh" {
  security_group_id    = aws_security_group.allows_ssh_more.id
  network_interface_id = data.aws_instance.instance.network_interface_id
}
resource "aws_network_interface_sg_attachment" "sg_attach_db" {
  security_group_id    = module.sq-sqlserver.id  # module's output
  network_interface_id = data.aws_instance.instance.network_interface_id
}

