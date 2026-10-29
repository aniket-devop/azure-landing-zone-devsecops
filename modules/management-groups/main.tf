terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Root of the hierarchy. With no parent set, it sits directly under Tenant Root Group.
resource "azurerm_management_group" "org" {
  name                       = var.org_id
  display_name               = var.org_display_name
  parent_management_group_id = var.parent_management_group_id
}

# --- Top level ---------------------------------------------------------------
resource "azurerm_management_group" "platform" {
  name                       = "${var.org_id}-platform"
  display_name               = "Platform"
  parent_management_group_id = azurerm_management_group.org.id
}

resource "azurerm_management_group" "landing_zones" {
  name                       = "${var.org_id}-landing-zones"
  display_name               = "Landing Zones"
  parent_management_group_id = azurerm_management_group.org.id
}

resource "azurerm_management_group" "sandbox" {
  name                       = "${var.org_id}-sandbox"
  display_name               = "Sandbox"
  parent_management_group_id = azurerm_management_group.org.id
}

resource "azurerm_management_group" "decommissioned" {
  name                       = "${var.org_id}-decommissioned"
  display_name               = "Decommissioned"
  parent_management_group_id = azurerm_management_group.org.id
}

# --- Platform children -------------------------------------------------------
resource "azurerm_management_group" "identity" {
  name                       = "${var.org_id}-identity"
  display_name               = "Identity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "management" {
  name                       = "${var.org_id}-management"
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "connectivity" {
  name                       = "${var.org_id}-connectivity"
  display_name               = "Connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
}

# --- Landing zone children ---------------------------------------------------
resource "azurerm_management_group" "corp" {
  name                       = "${var.org_id}-corp"
  display_name               = "Corp"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "online" {
  name                       = "${var.org_id}-online"
  display_name               = "Online"
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

locals {
  ids = {
    org            = azurerm_management_group.org.id
    platform       = azurerm_management_group.platform.id
    landing_zones  = azurerm_management_group.landing_zones.id
    sandbox        = azurerm_management_group.sandbox.id
    decommissioned = azurerm_management_group.decommissioned.id
    identity       = azurerm_management_group.identity.id
    management     = azurerm_management_group.management.id
    connectivity   = azurerm_management_group.connectivity.id
    corp           = azurerm_management_group.corp.id
    online         = azurerm_management_group.online.id
  }
}

# Move existing subscriptions into the hierarchy.
resource "azurerm_management_group_subscription_association" "this" {
  for_each = var.subscription_associations

  management_group_id = local.ids[each.value.management_group]
  subscription_id     = "/subscriptions/${each.value.subscription_id}"
}
