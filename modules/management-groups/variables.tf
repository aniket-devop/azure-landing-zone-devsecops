variable "org_id" {
  description = "Short identifier used as the root management group name and as a prefix for all children (e.g. \"contoso\")."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{2,20}$", var.org_id))
    error_message = "org_id must be 2-20 characters: lowercase letters, digits and hyphens."
  }
}

variable "org_display_name" {
  description = "Display name of the root management group."
  type        = string
}

variable "parent_management_group_id" {
  description = "Optional parent. Leave null to place the hierarchy under Tenant Root Group."
  type        = string
  default     = null
}

variable "subscription_associations" {
  description = "Subscriptions to place in the hierarchy. management_group must be one of the keys exposed in the 'ids' output."
  type = map(object({
    management_group = string
    subscription_id  = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for s in values(var.subscription_associations) :
      contains(["platform", "identity", "management", "connectivity", "landing_zones", "corp", "online", "sandbox", "decommissioned"], s.management_group)
    ])
    error_message = "management_group must be one of: platform, identity, management, connectivity, landing_zones, corp, online, sandbox, decommissioned."
  }
}
