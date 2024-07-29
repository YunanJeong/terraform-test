######################################################################
# Set Up Security Groups
######################################################################
resource "aws_security_group" "allows_basic" {
  name = "allows_basic_${var.tags.Name}"
  ingress {
    description = "allows all inbounds from my workspace"
    protocol    = "-1"
    cidr_blocks = var.work_cidr_blocks
    from_port   = 0
    to_port     = 0
  }
  egress { # 인스턴스에서 외부로 나가는 request 모두 허용. 이를 없애면 유사 IDC환경 테스트 가능.
    description = "allows all outbound (apt, ping, ...)"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

######################################################################
# Server Instance
######################################################################
locals {
  # subnet_id_list 미할당시 자동선택 ("")  
  valid_subnet_id_list = length(var.subnet_id_list) > 0 ? var.subnet_id_list : [for i in range(var.node_count) : ""]
}
resource "aws_instance" "server" {
  count         = var.node_count
  ami           = var.ami
  instance_type = var.instance_type
  # merge에서 나열 순서대로 Update된다.
  tags = merge(
    var.tags,
    { Name = "${var.tags.Name}-${count.index}" },
  )

  key_name  = var.key_name
  subnet_id = local.valid_subnet_id_list[count.index]
  vpc_security_group_ids = [ # subnet 지정시 보안그룹은 name이 아닌 id로 등록
    aws_security_group.allows_basic.id,
  ]
  ebs_optimized = true # EBS최적화 (인스턴스와 볼륨 간 I/O속도 개선)  # 인스턴스타입 따라 비활성화될 수 있음
  root_block_device {
    volume_size = var.volume_size
    delete_on_termination = true  # default
  }
  # ebs_block_device {}             # 추가 볼륨 or 스냅샷 가져올 때 사용


}

######################################################################
# Mutual Security Groups between Multiple Instances
######################################################################
# 인스턴스 간 보안그룹 생성
resource "aws_security_group" "allows_mutual" {
  name = "allows_mutual_${var.tags.Name}"
  ingress {
    from_port   = 0
    to_port     = 0
    description = "node to node"
    protocol    = "-1"

    # 할당된 인스턴스 ip에 문자열 '/32'를 붙이고 리스트로 반환
    cidr_blocks = concat(
      [for ip in aws_instance.server[*].public_ip : replace(ip, ip, "${ip}/32")],
      [for ip in aws_instance.server[*].private_ip : replace(ip, ip, "${ip}/32")]
    )
  }
}
# 인스턴스 간 보안그룹을 각각 인스턴스에 등록
data "aws_instance" "created_node" {
  count       = var.node_count                      # 반복문 효과
  instance_id = aws_instance.server[count.index].id # module's output
}
resource "aws_network_interface_sg_attachment" "sg_attach" {
  count                = var.node_count # 반복문 효과
  security_group_id    = aws_security_group.allows_mutual.id
  network_interface_id = data.aws_instance.created_node[count.index].network_interface_id
}

######################################################################
# Server Commands (초기 구성)
######################################################################
resource "null_resource" "server_remote" {
  # remote-exec를 위한 ssh connection 셋업
  count = var.node_count
  connection {
    type        = "ssh"
    host        = aws_instance.server[count.index].public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    agent       = false
  }

  # 실행된 원격 인스턴스에서 수행할 cli명령어
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait", # cloud-init이 끝날 떄 까지 기다린다. 에러 예방 차원에서 항상 써준다.
      "mkdir terraform-done",
    ]
  }
}

