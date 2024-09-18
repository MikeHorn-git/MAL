# Available OS
* [Blackarch](https://www.blackarch.org/index.html)
* [FlareVM](https://github.com/mandiant/flare-vm)
* [REMnux](https://docs.remnux.org/)

# Requirements
* Packer
* Ssh
* Vagrant
* Virtualbox
Tested on Arch linux.

# Virtualbox
## Build Blackarch
```bash
git clone https://github.com/MikeHorn-git/MAL.git
cd MAL/packer
packer init blackarch.pkr.hcl
packer build blackarch.pkr.hcl
```

## Build FlareVM
Place your Windows iso in iso/ directory. Default name is Windows_11.iso
```bash
git clone https://github.com/MikeHorn-git/MAL.git
cd MAL/packer
packer init flarevm.pkr.hcl
packer build flarevm.pkr.hcl
```
Stop the VM manually, after the FlareVM script is ended.
Default shutdown_timeout is 2h.

## Build REMnux
```bash
git clone https://github.com/MikeHorn-git/MAL.git
cd MAL/packer
packer init remnux.pkr.hcl
packer build remnux.pkr.hcl
```
When the VM is up :
```bash
sudo systemctl start ssh
```
Default ssh_timeout is 5m.

# Custom FlareVM
* Modify config/config.xml
* MAL used the [default](https://github.com/mandiant/flare-vm/blob/main/config.xml) one

# Credits
* [Baune8D](https://github.com/Baune8D/packer-windows-desktop/tree/main)

# To-Do
- [x] Blackarch Support
- [ ] Nix Integration
- [ ] Proxmox Support
- [ ] Qemu Support
