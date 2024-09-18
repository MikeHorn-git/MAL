packer {
  required_version = ">= 1.10.0"
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
  required_plugins {
      vagrant = {
        version = "~> 1"
        source = "github.com/hashicorp/vagrant"
    }
  }
}

variable "guest_os_type" {
  type    = string
  default = "Windows11_64"
}

variable "iso_url" {
  type    = string
  default = "../iso/Windows_11.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:36de5ecb7a0daa58dce68c03b9465a543ed0f5498aa8ae60ab45fb7c8c4ae402"
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "memory" {
  type    = string
  default = "4096"
}

variable "disk_size" {
  type    = string
  default = "90000"
}

variable "ssh_timeout" {
  type    = string
  default = "15m"
}

variable "shutdown_timeout" {
  type    = string
  default = "2h"
}

variable "vm_name" {
  type = string
  default = "FlareVM"
}

source "virtualbox-iso" "virtualbox" {
  guest_os_type    = var.guest_os_type
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  cpus             = var.cpus
  memory           = var.memory
  disk_size        = var.disk_size
  communicator     = "ssh"
  ssh_username     = "flare"
  ssh_password     = "flare"
  ssh_timeout      = var.ssh_timeout
  disable_shutdown = true
  shutdown_command = "none"
  shutdown_timeout = var.shutdown_timeout
  vm_name          = var.vm_name
  output_directory = var.vm_name

  floppy_files = [
    "../config/autounattend.xml",
    "../config/config.xml",
    "../scripts/ssh.ps1"
  ]
}

build {
  name    = "FlareVM"
  sources = ["source.virtualbox-iso.virtualbox"]
  
  provisioner "powershell" {
    inline = [
    "Invoke-WebRequest -Uri https://raw.githubusercontent.com/mandiant/flare-vm/main/install.ps1 -OutFile install.ps1",
    "Unblock-File ./install.ps1",
    "Set-ExecutionPolicy Unrestricted -Scope Process -Force",
    "Set-ExecutionPolicy Unrestricted -Force",
    "./install.ps1 -customConfig A:\\config.xml -password flare -noWait -noGui -noChecks",
    ]
  }

  post-processor "vagrant" {
    output = "./output/FlareVM.box"
  }
}
