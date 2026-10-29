terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Partial configuration: the pipeline supplies the storage account details with
  # -backend-config flags, and authenticates with OIDC (ARM_USE_OIDC=true).
  backend "azurerm" {
    key              = "platform.tfstate"
    use_azuread_auth = true
  }
}

# Management subscription (default). Also used for tenant-level resources.
provider "azurerm" {
  features {}
  subscription_id = var.management_subscription_id
}

# Connectivity subscription, where the hub network lives.
provider "azurerm" {
  alias = "connectivity"
  features {}
  subscription_id = var.connectivity_subscription_id
}

locals {
  tags = merge(var.tags, { managed-by = "terraform" })
}

module "management_groups" {
  source = "../../modules/management-groups"

  org_id           = var.org_id
  org_display_name = var.org_display_name

  subscription_associations = {
    management = {
      management_group = "management"
      subscription_id  = var.management_subscription_id
    }
    connectivity = {
      management_group = "connectivity"
      subscription_id  = var.connectivity_subscription_id
    }
  }
}

module "policy" {
  source = "../../modules/policy"

  management_group_ids = module.management_groups.ids
  allowed_locations    = var.allowed_locations
  required_tags        = var.required_tags
  enforce              = var.policy_enforce
}

module "monitoring" {
  source = "../../modules/monitoring"

  name_prefix            = var.org_id
  location               = var.location
  log_retention_days     = var.log_retention_days
  security_contact_email = var.security_contact_email
  tags                   = local.tags

  depends_on = [module.management_groups]
}

module "hub" {
  source = "../../modules/networking-hub"

  providers = {
    azurerm = azurerm.connectivity
  }

  name_prefix                = var.org_id
  location                   = var.location
  address_space              = var.hub_address_space
  spoke_address_spaces       = var.spoke_address_spaces
  deploy_firewall            = var.deploy_firewall
  deploy_bastion             = var.deploy_bastion
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  tags                       = local.tags

  depends_on = [module.management_groups]
}
