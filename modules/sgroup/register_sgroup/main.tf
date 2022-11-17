
######################################################################
# 보안그룹을 여러 인스턴스에 등록하기 위한 모듈
######################################################################
data "aws_instance" "target_node" {
    count       = length(var.instance_id_list)
    instance_id = var.instance_id_list[count.index]
}
resource "aws_network_interface_sg_attachment" "sg_attach" {
    count                = length(var.instance_id_list)
    security_group_id    = var.sgroup_id
    network_interface_id = data.aws_instance.target_node[count.index].network_interface_id
}