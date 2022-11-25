######################################################################
# Set Up Basic
######################################################################
variable "ami"{  default = "ami-063454de5fe8eba79" } # "Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-04-20"
variable "instance_type"{  default = "t2.micro"  }
variable "tags"{
  description = "instance tags"
  type = map(string)
  default = ({
    Name    = "basic ubuntu by terraform"
    Owner   = "xxxxx@gmail.com"
    Service = "tag-Service"
  })
}
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

