# terraform apply시 사용될 변수들을 다음과 같이 정의할 수 있다.
# 다른 tf파일에서 var.instance_name 과 같이 값을 불러올 수 있다.

/* 하드코딩을 대신할 민감한 정보 처리 방법*/
# config 파일용도로 variable.tf 및 variable.tfvars를 별도 생성하여 사용할 수 있다.
# 보편적, 관례적으로는 다음과 같이 처리한다.
# - variable.tf에서는 변수의 '존재'만 표기하고,
# - variable.tfvars에서 config 내용을 기술한다.
# => 이 경우, tf파일은 git commit 해주고,  tfvars파일은 git commit 하면 안된다.

######################################################################
# Set Up Ubuntu Example Server
######################################################################
variable "default_ami"{
  # 기본 우분투
  description = "Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-04-20"
  type = string
  default = "ami-063454de5fe8eba79"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "tags"{
    description = "instance tags"
    type = map(string)
    default = ({
      Name = "yunan-test-terraform-defaultname"
      Owner = "xxxxx@gmail.com"
      Service = "tag-Service"
    })
}

variable "key_pair_name"{
  type = string
  default = "key_pair_name"
}

variable "private_key_path"{
  type = string
  default = "Directory of key_pair_file(pem)"
}

variable "sgroup_name"{
  type = string
  description = "Name of Security Group"
}

variable "cidr_blocks_list"{
  type = list(string)
  description = "List of Allowed Source IP in Security Group"
}

######################################################################
#Set Up Windows SQL Server
######################################################################
# 기본 윈도우서버 + MSSQL
variable "windows_ami"{
  description = "Microsoft Windows Server 2019 Full Locale English with SQL Standard 2019 AMI provided by Amazon"
  type = string
  default = "ami-07b8e1b00269f1a3c"
}
variable "windows_tags"{}
variable "windows_instance_type"{
  description = "windows mssql server needs m5.xlarge"
  type = string
  default = "m5.large"
}
variable "db_user" {}
variable "db_passwd" {}
variable "db_port" {
  default = 1433
}

######################################################################
#Set Up Existing Git Server
######################################################################
variable "git_info"{
  type = map(string)
  default = ({
    user = "yunan"
    token = ""
  })
}
variable "gitlab_instance"{
  default = ""
}
