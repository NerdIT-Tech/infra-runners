module "gh_runners" {
  source   = "../../modules/proxmox-runner"
  count    = var.runner_count

  runner_name     = "gh-runner-prod-${format("%02d", count.index + 1)}"
  proxmox_node    = var.proxmox_nodes[count.index % length(var.proxmox_nodes)]
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
