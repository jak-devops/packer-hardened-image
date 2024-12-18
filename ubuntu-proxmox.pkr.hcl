# Déclaration des plugins requis pour Packer
packer {
  required_plugins {
    proxmox = {
      version = "~> 1.2.1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# Variables pour les credentials et configurations Proxmox
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

# Définition de la source Packer pour Proxmox
source "proxmox-iso" "ubuntu-hardened" {
  proxmox_url               = var.proxmox_url
  username                  = var.proxmox_username
  password                  = var.proxmox_password
  node                      = var.proxmox_node
  insecure_skip_tls_verify  = true   # Ignore la vérification TLS pour les connexions non sécurisées

  # Commandes pour automatiser le démarrage de l'ISO (boot_command)
  boot_command = [

  ]

  # Configuration ISO pour la machine virtuelle
  boot_iso {
    type       = "scsi"
    iso_file   = "local:iso/ubuntu-22.04.5-live-server-amd64.iso"
    iso_checksum = "sha256:9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
    unmount    = true
  }

  # Configuration de la VM
  vm_id         = 9000
  vm_name       = "ubuntu-hardened"
  template_name = "ubuntu-hardened-template"

  # Configuration réseau de la VM
  network_adapters {
    model  = "virtio"  # Utilise le modèle "virtio" pour de meilleures performances
    bridge = "vmbr0"   # Pont réseau utilisé sur Proxmox
  }

  # Configuration des disques de la VM
  disks {
    type         = "scsi"       # Utilisation du stockage SCSI
    storage_pool = "local-lvm"  # Pool de stockage dans Proxmox
    disk_size    = "8G"         # Taille du disque de la VM
  }

  # Configuration HTTP pour Cloud-init (pour automatiser l'installation de l'OS)
  http_directory = "http"  # Répertoire local pour les fichiers Cloud-init

  # Configuration SSH pour la VM
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "20m"
}

# Bloc Build : définit le processus de construction
build {
  sources = ["source.proxmox-iso.ubuntu-hardened"]

  # Provisioner "shell" pour exécuter des scripts après la création de la VM
provisioner "shell" {
  inline = [
    "bash scripts/updates.sh",       # Appliquer les mises à jour
    "bash scripts/hardening.sh",     # Appliquer les mesures de sécurisation
    "bash scripts/validate.sh",      # Valider les étapes précédentes
    "if [ $? -eq 0 ]; then bash scripts/cleanup.sh; else echo 'Validation échouée, arrêt.' && exit 1; fi"
  ]
}
