terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.66.1"
    }
  }
}

provider "proxmox" {
  endpoint  = var.pm_api_url
  api_token = "${var.pm_user}=${var.pm_password}"
  insecure  = true
}

resource "proxmox_virtual_environment_vm" "db_host" {
  name        = "iac-state-db"
  description = "Managed by Terraform - Bootstrap State Host"
  tags        = ["bootstrap", "database", "terraform"]
  
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

output "db_ip" {
  value = proxmox_virtual_environment_vm.db_host.ipv4_addresses[1][0]
}
