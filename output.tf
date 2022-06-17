# $terraform apply 후, 아래 내용에 해당하는 정보가 stdout으로 출력된다.
# 여기서는 인스턴스 ID와 IP 예시이다.
# infra가 실행중일 떄, $terraform output으로도 조회가능하다.
# output들은 현재 infra나 다른 terraform 프로젝트에서 사용가능하다.

######################################################################
# Set Up Ubuntu Example Server
######################################################################
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "instance_tags_info" {
  description = "Instance Tags"
  value = aws_instance.app_server.tags
}

######################################################################
#Set Up Windows SQL Server
######################################################################
output "win_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.windows_server.id
}

output "win_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.windows_server.public_ip
}

output "win_instance_tags_info" {
  description = "Instance Tags"
  value = aws_instance.windows_server.tags
}


