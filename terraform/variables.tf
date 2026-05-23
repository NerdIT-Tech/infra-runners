variable "pm_api_url" {
  type        = string
  description = "Proxmox API URL"
}

variable "pm_user" {
  type        = string
  description = "Proxmox API user"
}

variable "pm_password" {
  type      = string
  sensitive = true
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key content"
}

variable "ssh_private_key" {
  type        = string
  description = "SSH private key content"
  sensitive   = true
}

variable "runner_count" {
  type    = number
  default = 2
}

# Default infrastructure settings
variable "proxmox_node" {
  type    = string
  default = "proxmoxnode01"
}

variable "template_vmid" {
  type    = number
  default = 900
}

variable "pool" {
  type    = string
  default = "infra"
}

variable "target_storage" {
  type    = string
  default = "local-lvm"
}
