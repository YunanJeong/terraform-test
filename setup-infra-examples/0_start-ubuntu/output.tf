output "id" {
  description = "ID of the EC2 instance"
  value       = module.ubuntu.id
}
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ubuntu.public_ip
}
output "tags" {
  description = "Instance Tags"
  value = module.ubuntu.tags
}

