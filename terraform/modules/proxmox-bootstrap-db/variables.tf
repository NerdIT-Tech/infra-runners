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
  description = "SSH public key for cloud-init"
}

variable "proxmox_node" {
  type    = string
  default = "proxmoxnode01"
}

variable "template_vmid" {
  type    = number
}

variable "target_storage" {
  type    = string
  default = "local-lvm"
}

variable "vm_name" {
  type    = string
  default = "iac-state-db"
}

variable "tags" {
  type        = map(string)
  description = "Standardized tags for resource governance. Mandatory keys: org:service, org:environment, org:owner, org:project, org:cleanup-policy"

  validation {
    condition = alltrue([
      for key in ["org:service", "org:environment", "org:owner", "org:project", "org:cleanup-policy"] :
      contains(keys(var.tags), key)
    ])
    error_message = "Mandatory tags missing. Please ensure the following tags are provided: org:service, org:environment, org:owner, org:project, org:cleanup-policy."
  }
}
