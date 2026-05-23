resource "proxmox_virtual_environment_vm" "runner" {
  name      = var.runner_name
  vm_id     = var.vmid != 0 ? var.vmid : null
  node_name = var.proxmox_node
  pool_id   = var.pool

  clone {
    vm_id = var.template_vmid # BPG provider prefers ID for cloning
  }

  agent {
    enabled = true
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory_mb
  }

  network_device {
    bridge = var.bridge
  }

  disk {
    datastore_id = var.target_storage
    interface    = "scsi0"
    size         = 32
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

  # Wait for guest agent to be ready
  provisioner "remote-exec" {
    inline = ["echo 'Runner is up'"]
    connection {
      type        = "ssh"
      user        = "runner"
      host        = self.ipv4_addresses[1][0] # Adjusting for BPG IP reporting
      private_key = var.ssh_private_key
    }
  }
}
