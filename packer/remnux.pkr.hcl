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
  type    = string
  default = "https://netcologne.dl.sourceforge.net/project/remnux/ova-virtualbox/remnux-v7-focal-virtualbox.ova?viasf=1"
}

variable "checksum" {
  type    = string
  default = "sha256:412689aabf7d203c3fb46d141704671a1dbf858b13b404f0bbd0096f6d6bd7b9"
}

variable "ssh_timeout" {
  type    = string
  default = "5m"
}

variable "vm_name" {
  type    = string
  default = "REMnux"
}

variable "headless" {
  type    = bool
  default = false
}

source "virtualbox-ovf" "virtualbox" { 
  source_path               = var.source_path
  checksum                  = var.checksum
  communicator              = "ssh"
  ssh_username              = "remnux"
  ssh_password              = "malware"
  ssh_timeout               = var.ssh_timeout
  shutdown_command          = "echo 'packer' | sudo -S shutdown -P now"
  vm_name                   = var.vm_name
  output_directory          = var.vm_name
  headless                  = var.headless

  vboxmanage = [
   ["modifyvm", "{{.Name}}", "--memory", "4096"],
   ["modifyvm", "{{.Name}}", "--cpus", "2"],
  ]
}

build {
  name    = "remnux"
  sources = ["sources.virtualbox-ovf.virtualbox"]

  # Comment because remnux-cli have issues
  # https://github.com/REMnux/remnux-cli/issues/168
  provisioner "shell" {
    inline = [
      "sudo apt update -y",
      "sudo apt upgrade -y"
      # "sudo remnux upgrade",
      # "sudo remnux update"
    ]
  }

  post-processor "vagrant" {
    output = "./output/REMnux.box"
  }
}
