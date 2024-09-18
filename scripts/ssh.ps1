Add-WindowsCapability -Online -Name OpenSSH.Server
Start-Service sshd
