terraform {
  required_version = ">= 1.5.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.66.1"
    }
  }

  backend "pg" {
    # Typically passed via backend-config or set in a file
    # For migration, we'll keep the definition compatible
    # conn_str = "postgres://..." 
    schema_name = "production"
  }
}
