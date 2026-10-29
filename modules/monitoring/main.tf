terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.name_prefix}-mgmt-${var.location}"
  location = var.location
  tags     = var.tags
}

# Central workspace every other resource ships its logs to.
resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${var.name_prefix}-${var.location}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

# Subscription activity log: who changed what, and every policy decision.
resource "azurerm_monitor_diagnostic_setting" "activity_log" {
  name                       = "activity-log-to-law"
  target_resource_id         = data.azurerm_subscription.current.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  dynamic "enabled_log" {
    for_each = ["Administrative", "Security", "ServiceHealth", "Alert", "Recommendation", "Policy", "Autoscale", "ResourceHealth"]
    content {
      category = enabled_log.value
    }
  }
}

# Microsoft Defender for Cloud plans on this subscription.
resource "azurerm_security_center_subscription_pricing" "this" {
  for_each = toset(var.defender_plans)

  resource_type = each.value
  tier          = "Standard"
}

resource "azurerm_security_center_contact" "this" {
  count = var.security_contact_email == null ? 0 : 1

  name                = "default"
  email               = var.security_contact_email
  alert_notifications = true
  alerts_to_admins    = true
}
