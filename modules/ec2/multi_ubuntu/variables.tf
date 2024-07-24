######################################################################
# Set Up Basic
######################################################################
variable "node_count"     {default = 1}
variable "subnet_id_list" {default = []}
variable "ami"            {default = "ami-063454de5fe8eba79"} # "Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-04-20"
variable "instance_type"  {default = "t2.micro"}
variable "volume_size"    {default = 8} # GiB
variable "tags"{
  type = map(string)
  default = ({
    Name    = "yunan-ubuntu-terraform"
    Owner   = "xxxxx@gmail.com"
    Service = "tag-Service"
  })
}
######################################################################
# Key Pair for Secure Connection
######################################################################
variable "key_name"        {default = "my_keypair_name"}
variable "private_key_path"{default = "/home/ubuntu/.ssh/my_keypair_name.pem"}
variable "work_cidr_blocks"{
  description = "인스턴스에서 접속을 허가해줄 로컬PC의 public ip 목록"
  type = list(string)
  default = ["0.0.0.0/32", ]  # e.g.) my pc's public ip
}
