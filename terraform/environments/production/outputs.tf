output "runner_ips" {
  description = "IP addresses of the production runners"
  value = {
    for r in module.gh_runners : r.vm_name => r.ip_address
  }
}

output "runner_details" {
  description = "Detailed map of runner configuration"
  value = {
    for r in module.gh_runners : r.vm_name => {
      vmid = r.vmid
      ip   = r.ip_address
      node = r.node
    }
  }
}
