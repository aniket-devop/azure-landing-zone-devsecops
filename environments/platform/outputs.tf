output "management_group_ids" {
  value = module.management_groups.ids
}

output "hub_resource_group_name" {
  value = module.hub.resource_group_name
}

output "hub_vnet_id" {
  value = module.hub.vnet_id
}

output "hub_vnet_name" {
  value = module.hub.vnet_name
}

output "firewall_private_ip" {
  value = module.hub.firewall_private_ip
}

output "log_analytics_workspace_id" {
  value = module.monitoring.log_analytics_workspace_id
}
