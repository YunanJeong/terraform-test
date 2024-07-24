output "id" {
  description = "ID of the EC2 instance"
  value       = module.ubuntu.id_list
}
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ubuntu.public_ip_list
}
output "private_ip"{
  description = "Private IP address of the EC2 instance"
  value       = module.ubuntu.private_ip_list
}
output "subnet_id" {
  description = "AWS Subnet ID"
  value       = module.ubuntu.subnet_id_list
}
output "tags" {
  description = "Instance Tags"
  value = module.ubuntu.tags_list
}