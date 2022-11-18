######################################################################
# Set Up Security Groups
######################################################################
resource "aws_security_group" "allows_basic"{
  name = "allows_basic_"
  ingress {
    description = "for ssh"
    protocol    = "tcp"
    cidr_blocks = var.work_cidr_blocks # 접속할 PC
    from_port   = 22
    to_port     = 22
  }
  ingress {
    description = "for ping test"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = -1
    to_port     = -1
  }
  egress{ # 인스턴스에서 외부로 나가는 request 모두 허용. 이를 없애면 유사 IDC환경 테스트 가능.
    description = "allows all outbound (apt, ping, ...)"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port   = 0
  }
}

resource "aws_security_group" "allows_db"{
  name = "allows_db"
  ingress {
    from_port = var.db_port
    to_port = var.db_port
    description = "db connection"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "allow_winrm"{
  name = "allows_winrm"
  ingress {
    from_port = 3389
    to_port = 3389
    description = "rdp"
    protocol = "tcp"
    cidr_blocks = var.work_cidr_blocks
  }
  ingress {
    from_port = 5985
    to_port = 5986
    description = "WinRM"
    protocol = "tcp"
    cidr_blocks = var.work_cidr_blocks
  }
}

######################################################################
#Set Up Windows SQL Server
######################################################################
//템플릿파일 내 변수에 값 할당하기
data "template_file" "initdb" {
  template = file("${path.module}/scripts/init_db.sql")
  vars = {
    user = var.db_user,
    passwd = var.db_pass,
    port = var.db_port
  }
}
  #user_data = data.template_file.win_user_data.rendered

resource "aws_instance" "server" {
  ami = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.allows_basic.name, aws_security_group.allows_db.name, aws_security_group.allow_winrm.name]
  tags = var.tags
  key_name = var.key_name

  # user_data는 서버 초기 구성시 사용될 수 있는 메타데이터를 의미한다.(cmd스크립트)
  # AWS에서는 user_data를 활용한 winrm 초기설정이 추가로 필요하다.
  get_password_data = true # true이면, password_data 값을 terraform으로 가져온다.
  user_data_replace_on_change = true
  user_data = file("${path.module}/scripts/win_user_data.ps1")

  # remote-exec, file 등 여타 provisioner를 위한 connection 셋업
  connection {
    //https://www.terraform.io/language/resources/provisioners/connection
    # winrm connection에는 key파일 대신 password를 사용해야 한다.
    # password_data를 decrypted해서 password로 사용한다.
    host = self.public_ip
    timeout = "10m"
    type = "winrm"
    user = "Administrator"
    password = rsadecrypt(self.password_data, file(var.private_key_path))
  }

  # provisioner 끼리는 기술 순서대로 실행됨
  # 원격 인스턴스로 파일 전송
  provisioner "file" {
    content = data.template_file.initdb.rendered
    destination = "C:\\Users\\scripts\\init_db.sql"  # 원격 인스턴스 내 주소
  }

  # 실행된 원격 인스턴스에서 수행할 cmd명령어
  provisioner "remote-exec" {
    inline = [
      "mkdir C:\\Users\\test-winrm-remote-exec",
      "ping -n 15 localhost",  # 15초 대기. user_data와 충돌방지.
      "sqlcmd -i C:\\Users\\scripts\\init_db.sql"
    ]
  }

}

