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

# module을 활용해 보안그룹 작성 예시(ubuntu->sqlserver db접근 허용)
module "sq-sqlserver"{
    source = "../../modules/sgroup/allows_db"

    sgroup_name = "allows_db_${module.sqlserver.id}"
    allowed_list = ["${module.ubuntu.public_ip}/32"]
    db_port = 1433
}

# 보안그룹을 인스턴스에 등록(모듈 활용)
module "register_ssh_sgroup_to_nodes" {
    source = "../../modules/sgroup/register_sgroup"
    # Module's Variables
    sgroup_id        = aws_security_group.allows_ssh_more.id
    instance_id_list = ["${module.sqlserver.id}"]
}
module "register_db_sgroup_to_nodes" {
    source = "../../modules/sgroup/register_sgroup"
    # Module's Variables
    sgroup_id        = module.sq-sqlserver.id
    instance_id_list = ["${module.sqlserver.id}"]
}