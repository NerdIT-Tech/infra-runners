variable "pm_host" {
  type        = string
  description = "Proxmox Host (IP or FQDN)"
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
  type        = number
  description = "Number of runners to deploy"
  default     = 2
}

variable "proxmox_nodes" {
  type        = list(string)
  description = "List of Proxmox nodes for distribution"
  default     = ["proxmoxnode01"]
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

variable "repository" {
  type        = string
  description = "GitHub repository for the runners (e.g. org/repo)"
}

variable "created_at" {
  type        = string
  description = "Date string for the created-at tag (YYYY-MM-DD)"
  default     = "2026-05-25"
}
