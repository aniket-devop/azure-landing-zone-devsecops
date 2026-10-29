output "spoke_vnet_ids" {
  value = { for k, s in module.spoke : k => s.vnet_id }
}

output "spoke_subnet_ids" {
  value = { for k, s in module.spoke : k => s.subnet_ids }
}
