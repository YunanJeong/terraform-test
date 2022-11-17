
######################################################################
# 보안그룹을 여러 인스턴스에 등록하기 위한 모듈
######################################################################
# terraform에서 새로운 aws 인스턴스 생성시 보안그룹을 등록하는 것은 쉽다.
# 다만, 인스턴스를 생성하고난 후, or 이미 존재하는 인스턴스에 보안그룹을 등록하려면 아래와 같은 방법을 사용해야한다.
# 매번 작성하기 번거로우므로 묘듈화하여 사용한다.

data "aws_instance" "target_node" {
    count       = length(var.instance_id_list)
    instance_id = var.instance_id_list[count.index]
}
resource "aws_network_interface_sg_attachment" "sg_attach" {
    count                = length(var.instance_id_list)
    security_group_id    = var.sgroup_id
    network_interface_id = data.aws_instance.target_node[count.index].network_interface_id
}