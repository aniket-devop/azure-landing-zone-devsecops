terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

locals {
  rg_name = "rg-${var.name_prefix}-hub-${var.location}"

  # Carve the hub address space into the dedicated subnets Azure requires.
  # For a /22: firewall /26, bastion /26, gateway /27, none overlapping.
  subnet_firewall = cidrsubnet(var.address_space, 4, 0)
  subnet_bastion  = cidrsubnet(var.address_space, 4, 1)
  subnet_gateway  = cidrsubnet(var.address_space, 5, 4)
}

resource "azurerm_resource_group" "hub" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub" {
  name                = "vnet-${var.name_prefix}-hub-${var.location}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = [var.address_space]
  tags                = var.tags
}

# Subnet names below are mandated by Azure for these services.
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [local.subnet_firewall]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [local.subnet_bastion]
}

# Reserved for a VPN / ExpressRoute gateway (not deployed by this module).
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [local.subnet_gateway]
}

# --- Azure Firewall -----------------------------------------------------------
resource "azurerm_public_ip" "firewall" {
  count = var.deploy_firewall ? 1 : 0

  name                = "pip-${var.name_prefix}-fw-${var.location}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall_policy" "this" {
  count = var.deploy_firewall ? 1 : 0

  name                = "fwp-${var.name_prefix}-${var.location}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                 = "Standard"
  tags                = var.tags

  # Resolve FQDNs through the firewall's DNS proxy so FQDN rules work reliably.
  dns {
    proxy_enabled = true
  }

  threat_intelligence_mode = "Alert"
}

resource "azurerm_firewall_policy_rule_collection_group" "baseline" {
  count = var.deploy_firewall ? 1 : 0

  name               = "baseline"
  firewall_policy_id = azurerm_firewall_policy.this[0].id
  priority           = 200

  # Default stance is deny. Only platform updates are allowed out of the box;
  # workload-specific rules belong in their own rule collection groups.
  application_rule_collection {
    name     = "allow-platform-updates"
    priority = 100
    action   = "Allow"

    rule {
      name = "windows-update"
      protocols {
        type = "Https"
        port = 443
      }
      source_addresses      = var.spoke_address_spaces
      destination_fqdn_tags = ["WindowsUpdate"]
    }
  }
}

resource "azurerm_firewall" "this" {
  count = var.deploy_firewall ? 1 : 0

  name                = "afw-${var.name_prefix}-${var.location}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.this[0].id
  tags                = var.tags

  ip_configuration {
    name                 = "primary"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall[0].id
  }
}

resource "azurerm_monitor_diagnostic_setting" "firewall" {
  count = var.deploy_firewall && var.log_analytics_workspace_id != null ? 1 : 0

  name                       = "firewall-to-law"
  target_resource_id         = azurerm_firewall.this[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

# --- Azure Bastion ------------------------------------------------------------
resource "azurerm_public_ip" "bastion" {
  count = var.deploy_bastion ? 1 : 0

  name                = "pip-${var.name_prefix}-bas-${var.location}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "this" {
  count = var.deploy_bastion ? 1 : 0

  name                = "bas-${var.name_prefix}-${var.location}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  sku                 = "Basic"
  tags                = var.tags

  ip_configuration {
    name                 = "primary"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }
}
