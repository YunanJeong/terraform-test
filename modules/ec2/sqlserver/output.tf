# $terraform apply 후, 아래 내용에 해당하는 정보가 stdout으로 출력된다.
# 여기서는 인스턴스 ID와 IP 예시이다.
# infra가 실행중일 떄, $terraform output으로도 조회가능하다.
# output들은 현재 infra나 다른 terraform 프로젝트에서 사용가능하다.


######################################################################
#Set Up Windows SQL Server
######################################################################
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


