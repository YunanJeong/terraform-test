
# ubuntu 모듈에 입력될 variables
variable "ubuntu_node_count" {}
variable "ubuntu_ami" {}
variable "ubuntu_instance_type" {}
variable "ubuntu_tags" {}
variable "ubuntu_key_name" {}
variable "ubuntu_private_key_path" {}
variable "ubuntu_work_cidr_blocks" {}
variable "ubuntu_volume_size" {}
variable "ubuntu_subnet_id_list" { default = [] }
