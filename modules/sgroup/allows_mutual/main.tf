
######################################################################
# Mutual Security Groups between Multiple Instances
######################################################################
# 인스턴스 간 보안그룹 생성
resource "aws_security_group" "allows"{
    name = var.sgroup_name
    ingress{
        from_port   = 0
        to_port     = 0
        description = "node to node"
        protocol    = "-1"

        # 할당된 인스턴스 public ip에 문자열 '/32'를 붙이고 리스트로 반환
        cidr_blocks = [
          for ip in public_ip_list:
            replace(ip,ip,"${ip}/32")
        ]
    }
}