locals {
  common_tags = {
    "org:service"        = "gh-runner"
    "org:environment"    = "prd"
    "org:owner"          = "platform-eng"
    "org:project"        = "infra-runners"
    "org:cleanup-policy" = "ephemeral"
    "org:managed-by"     = "terraform"
    "org:repo"           = "github.com/${var.repository}"
    "org:created-at"     = var.created_at
  }
}

module "gh_runners" {
  source = "../../modules/proxmox-runner"
  count  = var.runner_count

  runner_name     = "gh-runner-prod-${format("%02d", count.index + 1)}"
  proxmox_node    = var.proxmox_nodes[count.index % length(var.proxmox_nodes)]
  template_vmid   = var.template_vmid
  pool            = var.pool
  target_storage  = var.target_storage
  ssh_public_key  = var.ssh_public_key
  ssh_private_key = var.ssh_private_key

  tags = local.common_tags
}

# SRE Best Practice: Ensure we never drop to 0 runners in the plan
check "minimum_runners" {
  assert {
    condition     = length(module.gh_runners) >= 1
    error_message = "CRITICAL: Infrastructure plan results in 0 runners. This will break the on-prem CI/CD cycle."
  }
}
