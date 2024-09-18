# Download and execute flarevm installer

Invoke-WebRequest -Uri https://raw.githubusercontent.com/mandiant/flare-vm/main/install.ps1 -OutFile install.ps1
Unblock-File ./install.ps1
Set-ExecutionPolicy Unrestricted -Force
./install.ps1 -password vagrant -noWait -noGui

#./install.ps1 -customConfig https://raw.githubusercontent.com/MikeHorn-git/MAL/main/config/config.xml -password vagrant -noWait -noGui
