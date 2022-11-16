output "ubuntu_id" {
  description = "ID of the EC2 instance"
  value       = module.ubuntu.id
}
output "ubuntu_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ubuntu.public_ip
}
output "ubuntu_tags" {
  description = "Instance Tags"
  value = module.ubuntu.tags
}

output "sqlserver_id" {
  description = "ID of the EC2 instance"
  value       = module.sqlserver.id
}
output "sqlserver_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.sqlserver.public_ip
}
output "sqlserver_tags" {
  description = "Instance Tags"
  value = module.sqlserver.tags
}

