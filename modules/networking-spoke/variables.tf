variable "name" {
  description = "Workload name used in resource names (e.g. \"corp-app1\")."
  type        = string
}

variable "location" {
  type = string
}

variable "address_space" {
  description = "Spoke VNet CIDR(s). Must not overlap the hub or other spokes."
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnet name to CIDR."
  type        = map(string)
}

variable "hub_vnet_id" {
  type = string
}

variable "hub_vnet_name" {
  type = string
}

variable "hub_resource_group_name" {
  type = string
}

variable "firewall_private_ip" {
  description = "Next hop for 0.0.0.0/0. Null skips the default route (e.g. when the hub firewall is not deployed)."
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
