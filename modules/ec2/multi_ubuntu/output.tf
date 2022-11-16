output "id_list" {
  description = "ID of the EC2 instance"
  # count로 인해 aws_instance.server가 여러개 있으므로, index를 지정해줘야 값을 호출가능
  # index 자리에 *(asterisk)를 쓰면 value에 전체 list 할당
  value       = aws_instance.server[*].id
}
output "public_ip_list" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.server[*].public_ip
}
output "mutual_cidr_blocks" {
  description = "public_ip_list 내용에 /32 붙임. 인스턴스 간 보안그룹 생성용"
  value       = [
    for ip in aws_instance.server[*].public_ip:
      replace(ip,ip,"${ip}/32")
  ]
}
output "tags_list" {
  description = "Instance Tags"
  # 다음과 같이 대괄호 대신 .(dot)으로 써도 전체 list 할당 (위의 대괄호 방식과 동일)
  value = aws_instance.server.*.tags
}

