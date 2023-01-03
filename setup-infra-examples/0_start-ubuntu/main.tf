#############################################################
# 다음은 미리 정의된 모듈을 가져와 인프라 구성시 활용하는 예제이다.
#############################################################
module "ubuntu" {
    # 상대경로 or github 경로 등으로 module을 가져올 수 있다.
    source = "../../modules/ec2/ubuntu"

    # Module's Variables (source 모듈의 variables.tf에서 정의한 변수들)
    # 모듈의 input에 해당하며, 모듈 사용시 다음과 같이 값을 할당해줘야 한다.
    # 값 할당은 main.tf, variables.tf에서도 할 수 있지만, 보안을 위해 별도 설정파일(config.tfvars)에서 가져온다.
    ami              = var.ubuntu_ami
    instance_type    = var.ubuntu_instance_type
    tags             = var.ubuntu_tags
    key_name         = var.ubuntu_key_name
    private_key_path = var.ubuntu_private_key_path
    work_cidr_blocks  = var.ubuntu_work_cidr_blocks
}
