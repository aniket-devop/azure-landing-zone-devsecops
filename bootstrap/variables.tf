variable "state_subscription_id" {
  description = "Subscription that will hold the Terraform state storage account (usually Management)."
  type        = string
}

variable "name_prefix" {
  type    = string
  default = "contoso"
}

variable "location" {
  type    = string
  default = "centralindia"
}

variable "state_storage_account_name" {
  description = "Globally unique, 3-24 lowercase letters and digits."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.state_storage_account_name))
    error_message = "Storage account names are 3-24 characters, lowercase letters and digits only."
  }
}

variable "github_org" {
  description = "GitHub user or organisation that owns the repository."
  type        = string
  default     = "aniket-devop"
}

variable "github_repo" {
  type    = string
  default = "azure-landing-zone-devsecops"
}

variable "github_environment" {
  description = "GitHub Environment the apply job runs in. Configure required reviewers on it."
  type        = string
  default     = "production"
}

variable "rbac_scope" {
  description = "Scope for the pipeline role assignments. Tenant Root Group (/providers/Microsoft.Management/managementGroups/<tenant-id>) so it can build the hierarchy; narrow it once the hierarchy exists."
  type        = string
}

variable "tags" {
  type = map(string)
  default = {
    managed-by = "terraform"
    purpose    = "terraform-state"
  }
}
