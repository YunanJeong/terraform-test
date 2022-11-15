#####################################################
# 다음과 같이 모듈을 가져와 인프라를 구성할 수 있다.
#####################################################
module "sqlserver" {
    source = "../../modules/ec2/sqlserver"

    # Module's Variables
    ami              = var.mssql_ami
    instance_type    = var.mssql_instance_type
    tags             = var.mssql_tags

    db_user = var.mssql_db_user
    db_pass = var.mssql_db_pass
    db_port = var.mssql_db_port

    key_name         = var.mssql_key_name
    private_key_path = var.mssql_private_key_path
    work_cidr_blocks = var.mssql_work_cidr_blocks
}
