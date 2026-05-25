output "db_ip" {
  value = proxmox_virtual_environment_vm.db_host.ipv4_addresses[1][0]
}
