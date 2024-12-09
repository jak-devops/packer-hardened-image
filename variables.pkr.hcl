variable "proxmox_url" {
  type = string
  description = "URL du serveur Proxmox"
}

variable "proxmox_username" {
  type = string
  description = "Nom d'utilisateur Proxmox"
}

variable "proxmox_password" {
  type = string
  description = "Mot de passe Proxmox"
  sensitive = true
}

variable "proxmox_node" {
  type = string
  description = "Nœud Proxmox à utiliser"
}

variable "ssh_username" {
  type = string
  description = "Nom d'utilisateur SSH pour la VM"
}

variable "ssh_password" {
  type = string
  description = "Mot de passe SSH pour la VM"
  sensitive = true
}
