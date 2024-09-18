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

variable "source_path" {
  type = string
  default = "https://ftp.halifax.rwth-aachen.de/blackarch/ova/blackarch-linux-2023.04.01.ova"
}

variable "checksum" {
  type = string
  default = "sha1:6c2ac1739b4f971bd7eef12d752ccf868a8065bd"
}

variable "ssh_timeout" {
  type = string
  default = "5m"
}

variable "vm_name" {
  type = string
  default = "blackarch"
}

variable "headless" {
  type = bool
  default = false
}

# Error on EULA
# https://github.com/hashicorp/packer-plugin-virtualbox/issues/3
source "virtualbox-ovf" "virtualbox" { 
  source_path               = var.source_path
  checksum                  = var.checksum
  communicator              = "ssh"
  ssh_username              = "root"
  ssh_password              = "blackarch"
  ssh_timeout               = var.ssh_timeout
  shutdown_command          = "none"
  vm_name                   = var.vm_name
  output_directory          = var.vm_name
  headless                  = var.headless
  import_flags              = ["--eula=accept"]

  vboxmanage = [
   ["modifyvm", "{{.Name}}", "--memory", "4096"],
   ["modifyvm", "{{.Name}}", "--cpus", "2"]
  ]
}

build {
  name    = "blackarch"
  sources = ["sources.virtualbox-ovf.virtualbox"]

  provisioner "shell" {
    inline = [
      "sudo pacman -Syyu --noconfirm"
    ]
  }

  post-processor "vagrant" {
    output = "./output/Blackarch.box"
  }
}
