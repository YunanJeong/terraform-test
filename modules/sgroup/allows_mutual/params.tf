######################################################################
# Module Input Params (variables.tf)
######################################################################
variable "sgroup_name"  {default = "allows_mutual"}
variable "public_ip_list" {default = ["0.0.0.0/32"]}

######################################################################
# Module Output Params (output.tf)
######################################################################
output "id" {
  description = "ID of the EC2 instance"
  value       = aws_security_group.allows.id
}