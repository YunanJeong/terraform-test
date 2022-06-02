# terraform-test
terraform aws example

## 사용법
- 해당경로에서,
    - `$terraform init`
        - 필요한 provider를 다운로드 받음.
    - `$terraform plan`
        - 변경될 내역을 미리 확인
    - `$terraform apply`
        - 코드 실행하여 실제 인프라에 적용
    - `$terraform apply -var-file="varfile.tfvars"`
        - 변수, config 정보 등이 담긴 tfvars 파일을 반영하여 실행
    - `$terraform apply -var='{변수명}={값}'`
        - 특정 변수만 변경하여 실행
    - `$terraform destroy`
        - 현재경로의 테라폼 프로젝트로 실행중인 인프라 리소스를 모두 종료

## 참고
- 변수 관련 document
    - https://www.terraform.io/language/values/variables
