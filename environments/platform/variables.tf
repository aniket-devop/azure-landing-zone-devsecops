variable "management_subscription_id" {
  description = "Subscription that hosts management resources. Supplied by the pipeline as TF_VAR_management_subscription_id."
  type        = string
}

variable "connectivity_subscription_id" {
  description = "Subscription that hosts the hub network. Supplied by the pipeline as TF_VAR_connectivity_subscription_id."
  type        = string
}

variable "org_id" {
  type = string
}

variable "org_display_name" {
  type = string
}

variable "location" {
  type = string
}

variable "allowed_locations" {
  type = list(string)
}

variable "required_tags" {
  type    = list(string)
  default = ["owner", "environment", "cost-center"]
}

variable "policy_enforce" {
  description = "false = audit only. Recommended for the very first apply on a tenant with existing resources."
  type        = bool
  default     = true
}

variable "log_retention_days" {
  type    = number
  default = 90
}

variable "security_contact_email" {
  type    = string
  default = null
}

variable "hub_address_space" {
  type    = string
  default = "10.0.0.0/22"
}

variable "spoke_address_spaces" {
  type    = list(string)
  default = ["10.1.0.0/16"]
}

variable "deploy_firewall" {
  type    = bool
  default = true
}

variable "deploy_bastion" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
