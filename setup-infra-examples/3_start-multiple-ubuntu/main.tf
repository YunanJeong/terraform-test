#############################################################
#
#############################################################
module "ubuntu" {
    source = "../../modules/ec2/multi_ubuntu"

    # Module's Variables
    node_count       = var.ubuntu_node_count
    ami              = var.ubuntu_ami
    instance_type    = var.ubuntu_instance_type
    tags             = var.ubuntu_tags
    key_name         = var.ubuntu_key_name
    private_key_path = var.ubuntu_private_key_path
    ssh_cidr_blocks  = var.ubuntu_ssh_cidr_blocks
}

# 인스턴스 간 보안그룹 생성
resource "aws_security_group" "allows_mutual"{
    name = "yunan_server_mutual"
    ingress{
        from_port   = 0
        to_port     = 0
        description = "node to node"
        protocol    = "-1"
        cidr_blocks = module.ubuntu.mutual_cidr_blocks
    }
}

# 새로운 보안그룹을 각 인스턴스에 추가
data "aws_instance" "created_node" {
    count       = var.ubuntu_node_count  # 반복문 효과
    instance_id = module.ubuntu.id_list[count.index]  # module's output
}
resource "aws_network_interface_sg_attachment" "sg_attach" {
    count                = var.ubuntu_node_count  # 반복문 효과
    security_group_id    = aws_security_group.allows_mutual.id
    network_interface_id = data.aws_instance.created_node[count.index].network_interface_id
}