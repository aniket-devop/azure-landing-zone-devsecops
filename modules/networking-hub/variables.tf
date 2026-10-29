variable "name_prefix" {
  description = "Prefix used in resource names."
  type        = string
}

variable "location" {
  description = "Azure region for the hub."
  type        = string
}

variable "address_space" {
  description = "Hub VNet CIDR. Use a /22 or larger so the firewall, bastion and gateway subnets fit."
  type        = string
  default     = "10.0.0.0/22"

  validation {
    condition     = can(cidrhost(var.address_space, 0)) && tonumber(split("/", var.address_space)[1]) <= 22
    error_message = "address_space must be a valid CIDR no smaller than a /22."
  }
}

variable "spoke_address_spaces" {
  description = "Address spaces of the spokes that are allowed through the baseline firewall rules."
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "deploy_firewall" {
  description = "Deploy Azure Firewall (Standard). This is the largest cost item in the hub; turn off for short-lived test runs."
  type        = bool
  default     = true
}

variable "deploy_bastion" {
  description = "Deploy Azure Bastion (Basic) for browser-based VM access."
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Workspace that receives firewall logs. Null to skip diagnostics."
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
