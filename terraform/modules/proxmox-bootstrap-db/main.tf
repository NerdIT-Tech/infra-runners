resource "proxmox_virtual_environment_vm" "db_host" {
  name        = var.vm_name
  description = "Managed by Terraform - Bootstrap State Host"
  tags        = [for k, v in var.tags : "${k}:${v}"]

  node_name = var.proxmox_node

  clone {
    vm_id = var.template_vmid
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = var.target_storage
    interface    = "scsi0"
    size         = 40
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
}
