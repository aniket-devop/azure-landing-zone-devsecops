output "resource_group_name" {
  value = azurerm_resource_group.hub.name
}

output "vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "firewall_private_ip" {
  description = "Private IP of the firewall, used as the next hop in spoke route tables. Null if the firewall is not deployed."
  value       = var.deploy_firewall ? azurerm_firewall.this[0].ip_configuration[0].private_ip_address : null
}
