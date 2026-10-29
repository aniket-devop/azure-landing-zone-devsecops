variable "workload_subscription_id" {
  description = "Subscription the spokes are deployed into. Supplied as TF_VAR_workload_subscription_id."
  type        = string
}

variable "connectivity_subscription_id" {
  description = "Hub subscription. Supplied as TF_VAR_connectivity_subscription_id."
  type        = string
}

variable "state_resource_group_name" {
  description = "Resource group of the Terraform state storage account (TF_VAR_state_resource_group_name)."
  type        = string
}

variable "state_storage_account_name" {
  description = "Terraform state storage account (TF_VAR_state_storage_account_name)."
  type        = string
}

variable "state_container_name" {
  type    = string
  default = "tfstate"
}

variable "location" {
  type = string
}

variable "spokes" {
  description = "Workload spokes to create. One entry per application / team."
  type = map(object({
    workload_type = string # corp | online
    address_space = list(string)
    subnets       = map(string)
  }))

  validation {
    condition     = alltrue([for s in values(var.spokes) : contains(["corp", "online"], s.workload_type)])
    error_message = "workload_type must be 'corp' or 'online'."
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}
