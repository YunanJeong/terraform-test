######################################################################
# Module Input Params (variables.tf)
######################################################################
variable "sgroup_name"  {default = "allows_db"}
variable "allowed_list" {default = ["0.0.0.0/32"]}
variable "db_port"      {default = 1433} # sql server default port

######################################################################
# Module Output Params (output.tf)
######################################################################
output "id" {
  description = "ID of the EC2 instance"
  value       = aws_security_group.allows.id
}