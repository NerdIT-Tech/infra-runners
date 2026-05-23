module "gh_runners" {
  source = "./modules/proxmox-runner"
  count  = var.runner_count

  runner_name     = "gh-runner-${format("%02d", count.index + 1)}"
  proxmox_node    = var.proxmox_node
  template_vmid   = var.template_vmid
  pool            = var.pool
  target_storage  = var.target_storage
  ssh_public_key  = var.ssh_public_key
  ssh_private_key = var.ssh_private_key
}

output "runner_ips" {
  description = "Map of runner names to their DHCP-assigned IP addresses"
  value       = { for r in module.gh_runners : r.vm_name => r.ip_address }
}

output "runner_details" {
  description = "Detailed map of runner configuration"
  value = {
    for r in module.gh_runners : r.vm_name => {
      vmid = r.vmid
      ip   = r.ip_address
    }
  }
}
