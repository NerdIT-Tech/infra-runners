terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.66.1"
    }
  }

  # RECOMMENDED: Use a remote backend for CI/CD consistency.
  # A simple Postgres instance in your homelab is a great option.
  # 
  # backend "pg" {
  #   conn_str = "postgres://terraform:PASSWORD@YOUR_IP:5432/terraform_state"
  # }
}

provider "proxmox" {
  endpoint  = var.pm_api_url
  api_token = "${var.pm_user}=${var.pm_password}"
  insecure  = true
}
