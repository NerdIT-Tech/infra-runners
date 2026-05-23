output "ip_address" {
  value = proxmox_virtual_environment_vm.runner.ipv4_addresses[1][0]
}

output "vm_name" {
  value = proxmox_virtual_environment_vm.runner.name
}

output "vmid" {
  value = proxmox_virtual_environment_vm.runner.vm_id
}

output "node" {
  value = proxmox_virtual_environment_vm.runner.node_name
}
