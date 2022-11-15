<powershell>
######################################################################
# WinRM 설정
######################################################################
# winrm 설정
winrm quickconfig -q
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'  # 암호화되지 않은 데이터의 전송을 허용
winrm set winrm/config/service/auth '@{Basic="true"}'  # WinRM 서비스에서 기본 인증을 사용하도록 설정

# EC2 보안그룹으로 관리되는 부분이지만, 만일을 위해 인스턴스 내 방화벽도 열어준다.
netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow  # http
netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow  # https

# winrm 재시작
net stop winrm
sc.exe config winrm start=auto
net start winrm

######################################################################
# MSSQL DB 초기화 관련 설정
######################################################################
# 로그인 인증을 Mixed 로 변경 (2017은 MSSSQL14, 2019는 MSSQL15)
Set-ItemProperty -Path 'HKLM:\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL15.MSSQLSERVER\\MSSQLServer' -Name LoginMode -Value 2
Restart-Service -Force MSSQLSERVER

# DB 및 유저 초기화
# sqlcmd -i C:\\Windows\\Temp\\init.sql

# test
mkdir C:\\Users\\test-user-data

</powershell>
