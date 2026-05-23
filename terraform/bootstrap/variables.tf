variable "pm_api_url" { type = string }
variable "pm_user" { type = string }
variable "pm_password" { type = string; sensitive = true }
variable "ssh_public_key" { type = string }
variable "proxmox_node" { type = string; default = "proxmoxnode01" }
variable "template_vmid" { type = number; default = 900 }
variable "target_storage" { type = string; default = "local-lvm" }
