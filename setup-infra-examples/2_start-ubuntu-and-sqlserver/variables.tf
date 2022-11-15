
# ubuntu 모듈에 입력될 variables
variable "ubuntu_ami"{  }
variable "ubuntu_instance_type"{}
variable "ubuntu_tags"{}

# sqlserver 모듈에 입력될 variables
variable "mssql_ami"{}
variable "mssql_instance_type"{}
variable "mssql_tags"{}
variable "mssql_db_user" {}
variable "mssql_db_pass" {}
variable "mssql_db_port" {}

# ubuntu, sqlserver 공통 variables
variable "key_name"{}
variable "private_key_path"{}
variable "work_cidr_blocks"{}

