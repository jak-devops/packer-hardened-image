packer {
  required_plugins {
    proxmox = {
      version = "~> 1.2.1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_url" {
  type = string
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_password" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "ssh_password" {
  type = string
}

source "proxmox-iso" "ubuntu-hardened" {
  proxmox_url             = var.proxmox_url
  username                = var.proxmox_username
  password                = var.proxmox_password
  node                    = var.proxmox_node
  insecure_skip_tls_verify = true

  # Boot ISO configuration
  boot_iso {
    type     = "scsi"
    iso_file = "local:iso/ubuntu-22.04.5-live-server-amd64.iso"
    iso_checksum = "sha256:9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
    unmount  = true
  }

  # VM Configuration
  vm_id         = 9000
  vm_name       = "ubuntu-hardened"
  template_name = "ubuntu-hardened-template"

  # Network configuration
  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Disk configuration
  disks {
    type         = "scsi"
    storage_pool = "local-lvm"
    disk_size    = "20G"
  }

  # HTTP configuration for cloud-init
  http_directory = "config"

  # Boot commands
  boot_command = [
    "<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>"
  ]

  # SSH configuration
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "20m"
}

build {
  sources = ["source.proxmox-iso.ubuntu-hardened"]

  provisioner "shell" {
    scripts = [
      "scripts/updates.sh",
      "scripts/hardening.sh",
      "scripts/cleanup.sh"
    ]
  }
}
