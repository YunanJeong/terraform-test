## tree
```
├── LICENSE
├── README.md
├── modules                           # 테라폼 모듈
│   ├── ec2                             # ec2모듈
│   └── sgroup                          # 보안그룹 모듈
├── setup-infra-examples              # 모듈 사용 예시
│   ├── 0_start-ubuntu
│   ├── 1_start-sqlserver
│   ├── 2_start-ubuntu-and-sqlserver
│   └── 3_start-multiple-ubuntu
└── terraform-test                    # 테라폼 코드 + 잡다한 참고용 주석 메모
```

## Requirement
- AWS CLI (AWS_KEY 사전등록)
- Terraform: v1.2.1 on linux_amd64
- Provisioning
  - 각 main.tf에서 다음과 같이 terraform version, 사용할 aws 리전 등을 명시적으로 기술할 수 있다.
  - 없어도 실행된다.(이미 설치된 terraform, awscli설정값 기준을 따른다.)
```
terraform {
  # "terraform registry"에서 제공하는 provider를 찾을 수 있음.
  # "$terraform init" 할 때 여기서 정의된 provider를 다운로드 받음.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 0.14.9"
}

# setup to specified provider
provider "aws" {
  profile = "default"
  region  = "ap-northeast-2" # seoul region
}
```