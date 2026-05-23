locals {
  # Distribute runners across nodes using modulo
  runner_configs = [
    for i in range(var.runner_count) : {
      name = "gh-runner-${format("%02d", i + 1)}"
      node = var.proxmox_nodes[i % length(var.proxmox_nodes)]
    }
  ]
}

module "gh_runners" {
  source = "./modules/proxmox-runner"
  count  = length(locals.runner_configs)

  runner_name     = locals.runner_configs[count.index].name
  proxmox_node    = locals.runner_configs[count.index].node
  template_vmid   = var.template_vmid
  pool            = var.pool
  target_storage  = var.target_storage
  ssh_public_key  = var.ssh_public_key
  ssh_private_key = var.ssh_private_key
}

# SRE Best Practice: Ensure we never drop to 0 runners in the plan
check "minimum_runners" {
  assert {
    condition     = length(module.gh_runners) >= 1
    error_message = "CRITICAL: Infrastructure plan results in 0 runners. This will break the on-prem CI/CD cycle."
  }
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
      node = r.node
    }
  }
}
