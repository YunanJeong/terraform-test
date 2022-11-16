output "id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.server.id
}
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.server.public_ip
}
output "tags" {
  description = "Instance Tags"
  value = aws_instance.server.tags
}

