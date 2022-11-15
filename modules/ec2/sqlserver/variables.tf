######################################################################
#Set Up Windows SQL Server
######################################################################
variable "ami"{ default = "ami-07b8e1b00269f1a3c" }  # "Microsoft Windows Server 2019 Full Locale English with SQL Standard 2019 AMI provided by Amazon"
variable "instance_type"{  default = "m5.large" }  # "windows mssql server needs at least m5.xlarge"
variable "tags"{}
variable "db_user" {}
variable "db_pass" {}
variable "db_port" { default = 1433 }

######################################################################
# Key Pair for Secure Connection
######################################################################
variable "key_name"{  default = "my_keypair_name"  }
variable "private_key_path"{  default = "/home/ubuntu/.ssh/my_keypair_name.pem"  }
variable "work_cidr_blocks"{
  description = "인스턴스에서 접속을 허가해줄 로컬PC의 public ip 목록"
  type = list(string)
  default = ["0.0.0.0/32", "x.x.x.x/32"]  # e.g.) my pc's public ip
}
