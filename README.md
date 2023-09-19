## tree

```sh
├── LICENSE
├── README.md
├── modules                         # 모듈 모음
│   ├── ec2                           # 인스턴스 종류 별 구분
│   │   ├── multi_ubuntu                # 모듈: 클린 ubuntu N개 및 필요한 보안그룹 등 설정 포함
│   │   ├── sqlserver                   # 모듈: sqlserver(mssql) 인스턴스 1개
│   │   └── ubuntu                      # 모듈: 클린 ubuntu 1개 및 필요한 보안그룹 등 설정 포함
│   └── sgroup                        # 자주 쓰는 보안그룹 설정을 모듈화
│       ├── allows_db                   # 보안그룹: db 접근 허용
│       ├── allows_mutual               # 보안그룹: 다중 인스턴스간 통신 허용
│       └── register_sgroup             # 보안그룹등록 모듈: 이미 생성된 인스턴스에 보안그룹을 쉽게 등록하기 위해 활용
├── setup-infra-examples            # 모듈 활용 예시
│   ├── 0_start-ubuntu                # ubuntu 인스턴스 1개 생성
│   ├── 1_start-sqlserver             # sqlserver 인스턴스 1개 생성
│   ├── 2_start-ubuntu-and-sqlserver  # sqlserver 및 보안그룹 모듈 활용, 추가 리소스 작성 등 예시
│   └── 3_start-multiple-ubuntu       # ubuntu 인스턴스 여러 개 생성
└── terraform-test                  # 테라폼 코드 + 잡다한 참고용 주석 메모
```

## 커맨드

- 해당경로에서,

```sh
# 초기화: 필요한 provider 다운로드 및 새 module 인식
terraform init

# syntax, 인프라 구성 등에 문제없는지 apply 전 미리 확인가능
terraform plan -var-file="./config.tfvars"

# 인프라 구축
terraform apply -var-file="./config.tfvars"

# 인프라 종료
terraform destroy -var-file="./config.tfvars"

# 인프라 정보 출력
terraform show

# Output 정보 출력
terraform output
```

## Requirement

- AWS CLI (AWS_KEY 사전등록)
- Terraform: v1.2.1 on linux_amd64
- Provisioning
  - 각 main.tf에서 다음과 같이 terraform version, 사용할 aws 리전 등을 명시적으로 기술할 수 있다.
  - 없어도 실행된다.(이미 설치된 terraform, awscli설정값 기준을 따른다.)

```py
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
