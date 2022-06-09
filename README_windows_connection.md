# Terraform으로 Windows Instance에 Connection하는 방법 및 AWS EC2에서 이슈
- 이 내용은 AWS EC2에서는 이슈가 있어 이용하기 힘든 방법이다.
- 일반적인 Terraform 사용시 이용가능한 방법을 남긴다.
- Connection 및 remote-exec와 관련된 변수 문서
    - https://www.terraform.io/language/resources/provisioners/connection

## terraform에서 ssh연결 및 remote-exec를 통한 명령어 전달
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
    target_platform = "windows" # ssh 전용 변수
    private_key = file(var.private_key_path) # ssh 전용 변수
    ...
}
```
- `key_name`: 클라우드 서비스에 미리 등록된 public key 이름을 입력해주는 자리다.
- `target_platform`: 디폴트는 "unix"다. Windows에 ssh연결시, "windows"라고 명시해준다.
- `private_key`: ssh 연결시, password 대신 개인키를 사용할 때 사용하는 변수

## terrafrom에서 winrm연결 및 remote-exec를 통한 명령어 전달
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
- `key_name`: 클라우드 서비스에 미리 등록된 public key 이름을 입력해주는 자리다.
- `get_password_data`: password_data를 terraform으로 가져올지 말지 결정하는 변수
- 'password_data'는 인스턴스 생성시, public key에 의해 생성된 encypted password를 의미한다.
- `self.password_data`: `get_password_data = true`일 때 password_data 값을 가져온다.
- `readecrypte({encrypted_password}, {private_key_file_path})`
    - 로컬에 있는 private key 파일을 이용해 password_data를 decrypted password로 변경하는 과정이다.


# Terraform에서 AWS EC2 Windows Instance에 연결하는 방법
    - terraform aws_instance 리소스 아래의 user_data 변수를 사용해서 스크립트를 전달하는 방식으로 가능.