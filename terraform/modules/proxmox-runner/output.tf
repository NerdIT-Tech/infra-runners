output "ip_address" {
  value = resource.proxmox_virtual_environment_vm.runner.ipv4_addresses[1][0]
}

output "vm_name" {
  value = resource.proxmox_virtual_environment_vm.runner.name
}

output "vmid" {
  value = resource.proxmox_virtual_environment_vm.runner.vm_id
}
