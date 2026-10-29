terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    key              = "landing-zones.tfstate"
    use_azuread_auth = true
  }
}

# Workload subscription: where the spokes are created.
provider "azurerm" {
  features {}
  subscription_id = var.workload_subscription_id
}

# Connectivity subscription: needed to create the hub-side peering.
provider "azurerm" {
  alias = "hub"
  features {}
  subscription_id = var.connectivity_subscription_id
}

# Read the hub details published by the platform environment.
data "terraform_remote_state" "platform" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = var.state_container_name
    key                  = "platform.tfstate"
    use_azuread_auth     = true
  }
}

locals {
  platform = data.terraform_remote_state.platform.outputs
  tags     = merge(var.tags, { managed-by = "terraform" })
}

module "spoke" {
  source   = "../../modules/networking-spoke"
  for_each = var.spokes

  providers = {
    azurerm     = azurerm
    azurerm.hub = azurerm.hub
  }

  name          = each.key
  location      = var.location
  address_space = each.value.address_space
  subnets       = each.value.subnets

  hub_vnet_id             = local.platform.hub_vnet_id
  hub_vnet_name           = local.platform.hub_vnet_name
  hub_resource_group_name = local.platform.hub_resource_group_name
  firewall_private_ip     = local.platform.firewall_private_ip

  tags = merge(local.tags, { workload = each.key, workload-type = each.value.workload_type })
}
