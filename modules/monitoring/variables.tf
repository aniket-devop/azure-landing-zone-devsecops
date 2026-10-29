variable "name_prefix" {
  description = "Prefix used in resource names (e.g. \"contoso\")."
  type        = string
}

variable "location" {
  description = "Azure region for the management resources."
  type        = string
}

variable "log_retention_days" {
  description = "Retention for the central Log Analytics workspace."
  type        = number
  default     = 90

  validation {
    condition     = var.log_retention_days >= 30 && var.log_retention_days <= 730
    error_message = "log_retention_days must be between 30 and 730."
  }
}

variable "defender_plans" {
  description = "Defender for Cloud plans to enable on this subscription."
  type        = list(string)
  default     = ["VirtualMachines", "StorageAccounts", "KeyVaults", "Arm"]
}

variable "security_contact_email" {
  description = "Email that receives high-severity Defender alerts. Null to skip."
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
