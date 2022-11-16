output "id" {
  description = "ID of the EC2 instance"
  value       = module.sqlserver.id
}
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.sqlserver.public_ip
}
output "tags" {
  description = "Instance Tags"
  value = module.sqlserver.tags
}

