######################################################################
# AWS EC2 실행시 가장 사용성이 좋은 기본 보안그룹
######################################################################
# 잠깐 사용 or 테스트 용도로 가장 무난한 설정
# 실제 Production 환경이라면, 보안그룹을 아래 내용보다 더 상세히 고려하는 것이 좋다.

resource "aws_security_group" "allows_basic"{
  name = "allows_basic_ubuntu"
  ingress{
    description = "allows all inbounds from my workspace"
    protocol  = "-1"
    cidr_blocks = var.work_cidr_blocks
    from_port = 0
    to_port   = 0
  }
  egress{
    # 인스턴스에서 외부로 나가는 request 모두 허용. 이를 없애면 유사 IDC환경 테스트 가능.
    # outbound 허용을 안해줘도 인스턴스에서 외부로 나가는 response는 문제없다.
    # terraform aws에서 보통 -1이 전체포트를 의미하지만 여기선 0을 쓴다.
    description = "allows all outbounds (apt, ping, ...)"
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port   = 0
  }
  /*
  ingress {
    description = "for ssh"
    protocol    = "tcp"
    cidr_blocks = var.work_cidr_blocks # 접속할 PC
    from_port   = 22
    to_port     = 22
  }

  ingress {
    # 전체포트는 [-1,-1]로 표기한다. [0,65535]는 에러발생.
    description = "for ping test"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = -1
    to_port     = -1
  }
  */
}