variable "management_group_ids" {
  description = "Output of the management-groups module. Must contain: org, landing_zones, corp."
  type        = map(string)

  validation {
    condition     = alltrue([for k in ["org", "landing_zones", "corp"] : contains(keys(var.management_group_ids), k)])
    error_message = "management_group_ids must contain the keys: org, landing_zones, corp."
  }
}

variable "allowed_locations" {
  description = "Azure regions resources may be deployed to."
  type        = list(string)
}

variable "required_tags" {
  description = "Tags that must be present on resources in the Landing Zones scope."
  type        = list(string)
  default     = ["owner", "environment", "cost-center"]
}

variable "enforce" {
  description = "Set false to run every assignment in audit-only (DoNotEnforce) mode while you assess impact."
  type        = bool
  default     = true
}
