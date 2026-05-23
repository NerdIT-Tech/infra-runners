terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.66.1"
    }
  }

  # SRE Best Practice: Use a remote backend for state.
  # This block is partially configured. Credentials should be provided
  # via -backend-config="conn_str=..." during 'terraform init'.
  backend "pg" {}
}

provider "proxmox" {
  endpoint  = var.pm_api_url
  api_token = "${var.pm_user}=${var.pm_password}"
  insecure  = true
}
