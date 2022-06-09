# terraform-test
Terraform Example (AWS)
1. EC2 Ubuntu 인스턴스 띄우고 원격 명령어 실행 테스트
2. EC2 Windows Server(+ SQL Server) 인스턴스 띄우고 DB 테스트

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

--------------------------------------------------------
# Terraform으로 Windows Instance에 Connection하는 방법 및 AWS EC2에서 이슈
- terraform에서 ssh연결 및 remote-exec를 통한 명령어 전달
    - AWS EC2 Windows Instance는 SSH를 지원하지 않아서 불가능
    - EC2 외에는 아래 방법 사용
    ```
    resource "aws_instance" "windows_server" {
      ...
      key_name = var.key_pair_name
      ...

    # remote-exec를 위한 connection 셋업
    connection {
        ...
        // Warning: Windows EC2 Instance doesn't support SSH connection.
        type = "ssh"
        target_platform = "windows" # ssh 전용
        private_key = file(var.private_key_path) # ssh 전용
        ...
    }
    ```
- terrafrom에서 winrm연결 및 remote-exec를 통한 명령어 전달
    - EC2에서 제대로 동작하지 않는 이슈가 있음 (무한 연결대기)
    - EC2 외에는 아래 방법 사용
    ```
    resource "aws_instance" "windows_server" {
      ...
      key_name = var.key_pair_name
      get_password_data = true
      ...

    # remote-exec를 위한 connection 셋업
    connection {
      ...
      password = rsadecrypt(self.password_data, file(var.private_key_path))
      ...
    }
    ```
# Terraform에서 AWS EC2 Windows Instance에 연결하는 방법
    - terraform aws_instance 리소스 아래의 user_data 변수를 사용해서 스크립트를 전달하는 방식으로 가능.