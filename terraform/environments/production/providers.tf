provider "proxmox" {
  endpoint  = "https://${var.pm_host}:8006/"
  api_token = "${var.pm_user}=${var.pm_password}"
  insecure  = true
}
