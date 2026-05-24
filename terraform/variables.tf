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

variable "runners" {
  type = map(object({
    node = string
  }))
  description = "Map of runner names to their configuration"
  default = {
    "gh-runner-01" = { node = "proxmoxnode01" }
    "gh-runner-02" = { node = "proxmoxnode02" }
    "gh-runner-03" = { node = "proxmoxnode03" }
  }
}

variable "janitor_tag" {
  type    = string
  default = "janitor:cleanup"
}

# Default infrastructure settings
variable "proxmox_nodes" {
  type        = list(string)
  description = "List of Proxmox nodes for HA distribution"
  default     = ["proxmoxnode01", "proxmoxnode02", "proxmoxnode03"]
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
