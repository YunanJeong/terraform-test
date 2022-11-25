######################################################################
# Module Input Params (variables.tf)
######################################################################
variable "sgroup_name"    {default = "allows_basic"}
variable "work_cidr_blocks"{
  description = "인스턴스에서 접속을 허가해줄 로컬PC의 public ip 목록"
  type = list(string)
  default = ["0.0.0.0/32", ]  # e.g.) my pc's public ip
}

######################################################################
# Module Output Params (output.tf)
######################################################################
output "id" {
  description = "ID of the EC2 instance"
  value       = aws_security_group.allows.id
}