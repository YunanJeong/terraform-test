
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
# 인스턴스 간 보안그룹을 각각 인스턴스에 등록
data "aws_instance" "created_node" {
    count       = var.node_count  # 반복문 효과
    instance_id = var.instance_id_list[count.index]  # module's output
}
resource "aws_network_interface_sg_attachment" "sg_attach" {
    count                = var.node_count  # 반복문 효과
    security_group_id    = aws_security_group.allows.id
    network_interface_id = data.aws_instance.created_node[count.index].network_interface_id
}