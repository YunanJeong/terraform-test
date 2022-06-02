# terraform apply시 사용될 변수들을 다음과 같이 정의할 수 있다.
# 다른 tf파일에서 var.instance_name 과 같이 값을 불러올 수 있다.

/* 하드코딩을 대신할 민감한 정보 처리 방법*/
# config 파일용도로 variable.tf 및 variable.tfvars를 별도 생성하여 사용할 수 있다.
# 관례적으로는 다음과 같이 쓸 수 있다.
## variable.tf에서는 변수의 '존재'만 표기하고,
## variable.tfvars에서 값을 할당한다.
### => 이 경우, tf파일은 git commit 해주고,  tfvars파일은 git commit 하면 안된다.

variable "default_ami"{
  # 기본 우분투
  description = "Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2022-04-20"
  type = string
  default = "ami-063454de5fe8eba79"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "tags"{
    description = "instance tags"
    type = map(string)
    default = ({
      Name = "yunan-test-terraform-defaultname"
      Owner = "xxxxx@gmail.com"
      Service = "tag-Service"
    })
}