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
  default = 3
  validation {
    condition     = var.runner_count >= 1
    error_message = "At least one runner must be maintained to avoid breaking the IaC pipeline."
  }
}

# Default infrastructure settings
variable "proxmox_nodes" {
  type        = list(string)
  description = "List of Proxmox nodes for HA distribution"
  default     = ["proxmoxnode01"]#, "proxmoxnode02", "proxmoxnode03"]
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

