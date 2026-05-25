variable "runner_name" {
  type        = string
  description = "Hostname for the runner VM"
}

variable "proxmox_node" {
  type        = string
  description = "Proxmox node name (e.g. pve01)"
}

variable "vmid" {
  type        = number
  description = "Optional VMID for the runner. If 0, Proxmox will auto-assign."
  default     = 0
}

variable "template_vmid" {
  type        = number
  description = "VMID of the cloud-init template VM"
}

variable "pool" {
  type        = string
  description = "Proxmox pool to place the VM in"
}

variable "target_storage" {
  type        = string
  description = "Storage for the VM disk"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for cloud-init"
}

variable "ssh_private_key" {
  type        = string
  description = "SSH private key for provisioning (optional)"
}

variable "bridge" {
  type        = string
  description = "Network bridge"
  default     = "vmbr0"
}

variable "cores" {
  type    = number
  default = 3
}

variable "memory_mb" {
  type    = number
  default = 2048
}

variable "tags" {
  type        = map(string)
  description = "Standardized tags for resource governance. Mandatory keys: org:environment, org:owner, org:project, org:cleanup-policy"

  validation {
    condition = alltrue([
      for key in ["org:environment", "org:owner", "org:project", "org:cleanup-policy"] :
      contains(keys(var.tags), key)
    ])
    error_message = "Mandatory tags missing. Please ensure the following tags are provided: org:environment, org:owner, org:project, org:cleanup-policy."
  }

  validation {
    condition     = contains(["prd", "stg", "dev"], lookup(var.tags, "org:environment", "unknown"))
    error_message = "The 'org:environment' tag must be one of: prd, stg, dev."
  }

  validation {
    condition     = contains(["ephemeral", "protected"], lookup(var.tags, "org:cleanup-policy", "unknown"))
    error_message = "The 'org:cleanup-policy' tag must be one of: ephemeral, protected."
  }
}
