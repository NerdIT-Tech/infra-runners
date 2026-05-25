resource "proxmox_virtual_environment_vm" "postgres" {
  name        = var.name
  description = "Managed by Terraform - PostgreSQL Database"
  tags        = [for k, v in merge(var.tags, local.service_tag) : "${k}:${v}"]

  vm_id     = var.vmid != 0 ? var.vmid : null
  node_name = var.proxmox_node
  pool_id   = var.pool

  clone {
    vm_id = var.template_vmid
  }

  agent {
    enabled = true
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory_mb
    floating  = var.memory_mb # Disable ballooning for more predictable CI performance
  }

  network_device {
    bridge = var.bridge
  }

  disk {
    datastore_id = var.target_storage
    interface    = "scsi0"
    size         = 40 # Increased default size
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      keys     = [var.ssh_public_key]
      username = "runner"
    }
  }

  on_boot = true

  lifecycle {
    # Ensure new runners are created before old ones are destroyed during updates
    create_before_destroy = true
  }
}
