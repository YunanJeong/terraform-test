variable "sg_name"{}
variable "allowed_list"{
  description = "보안그룹에서 허용할 public ip 목록"
  type = list(string)
  default = ["0.0.0.0/32", ]  # e.g.) my pc's public ip
}
