# terraform-test
Terraform Example(AWS)

## 요구사항
- awscli가 설치 및 세팅되어있어야 함.
- awscli에 등록된 access & secret key를 통해, terraform이 aws계정을 식별하고 인스턴스 띄운다.

## 사용법
- 해당경로에서,
    - `$terraform init`
        - 필요한 provider를 다운로드 받음
    - `$terraform plan`
        - 변경될 내역을 미리 확인
    - `$terraform apply`
        - 코드 실행하여 실제 인프라에 적용
    - `$terraform apply -var-file="{설정파일명}.tfvars"`
        - 변수, config 정보 등이 담긴 tfvars 파일을 반영하여 실행
        - tfvars파일은 보안정보 등이 포함되므로 git commit 하지않고, 로컬에서만 사용한다.
    - `$terraform apply -var='{변수명}={값}'`
        - 특정 변수만 변경하여 실행
    - `$terraform apply -auto-approve`
        - apply시, 관리자의 최종승인 yes 입력이 필요하다.
        - `-auto-approve`는 이를 생략시키는 옵션 (자동화할 때 쓸 필요성있음)
    - `$terraform destroy`
        - 현재경로의 테라폼 프로젝트로 실행중인 인프라 리소스를 모두 종료

## 참고
- 변수 관련 document
    - https://www.terraform.io/language/values/variables
