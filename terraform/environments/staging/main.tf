locals {
  environment_tag = {
    "org:environment" = "stg"
  }
}

module "gh_runners" {
  source = "../../modules/proxmox-runner"
  count  = var.runner_count

  runner_name     = "gh-runner-stage-${format("%02d", count.index + 1)}"
  proxmox_node    = var.proxmox_nodes[count.index % length(var.proxmox_nodes)]
  template_vmid   = var.template_vmid
  pool            = var.pool
  target_storage  = var.target_storage
  ssh_public_key  = var.ssh_public_key
  ssh_private_key = var.ssh_private_key

  tags = merge(local.environment_tag, {
    "org:owner"          = "platform-eng"
    "org:project"        = "infra-runners"
    "org:cleanup-policy" = "ephemeral"
    "org:managed-by"     = "terraform"
    "org:repo"           = "https://github.com/${var.repository}"
    "org:created-at"     = formatdate("YYYY-MM-DD", timestamp())
  })
}
