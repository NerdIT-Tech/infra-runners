output "db_ip" {
  value       = proxmox_virtual_environment_vm.db_host.ipv4_addresses[1][0]
  description = "IPv4 address of the bootstrap database host"
}

output "vmid" {
  value       = proxmox_virtual_environment_vm.db_host.vm_id
  description = "VMID of the bootstrap database host"
}
