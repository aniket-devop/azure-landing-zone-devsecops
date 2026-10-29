terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~> 4.0"
      configuration_aliases = [azurerm.hub]
    }
  }
}

# Default provider  = the subscription the spoke lives in.
# azurerm.hub       = the connectivity subscription, needed for the return peering.

resource "azurerm_resource_group" "spoke" {
  name     = "rg-${var.name}-net-${var.location}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-${var.name}-${var.location}"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [each.value]
}

# --- Network security ---------------------------------------------------------
resource "azurerm_network_security_group" "this" {
  for_each = var.subnets

  name                = "nsg-${var.name}-${each.key}"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  tags                = var.tags

  # Management ports are never reachable from the internet. Use Bastion.
  security_rule {
    name                       = "deny-internet-mgmt-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "3389"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

# --- Forced tunnelling through the hub firewall --------------------------------
resource "azurerm_route_table" "this" {
  name                = "rt-${var.name}-${var.location}"
  location            = azurerm_resource_group.spoke.location
  resource_group_name = azurerm_resource_group.spoke.name
  tags                = var.tags

  # Stop on-prem / gateway routes from bypassing the default route below.
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "default_via_firewall" {
  count = var.firewall_private_ip == null ? 0 : 1

  name                   = "default-via-firewall"
  resource_group_name    = azurerm_resource_group.spoke.name
  route_table_name       = azurerm_route_table.this.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "this" {
  for_each = var.subnets

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = azurerm_route_table.this.id
}

# --- Hub <-> spoke peering ----------------------------------------------------
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${var.name}-to-hub"
  resource_group_name       = azurerm_resource_group.spoke.name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider = azurerm.hub

  name                      = "peer-hub-to-${var.name}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
