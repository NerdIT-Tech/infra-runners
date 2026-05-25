output "ip_address" {
  # Robust way to find the first non-loopback IPv4 address reported by the agent
  value = element(concat([for ip in flatten(proxmox_virtual_environment_vm.runner.ipv4_addresses) : ip if !strcontains(ip, "127.0.0.1")], ["IP_NOT_FOUND"]), 0)
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
