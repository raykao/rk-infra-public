variable resource_group {
}

variable "location" {
  type = string
}

variable prefix {
	type = string
}


variable domain {
	type = string
}

variable vnet_address_space {
	type = string
}

variable hub_vnet {
}

variable hub_zone {
}

locals {
	domain = "${var.resource_group.location}.${var.domain}"
}

resource azurerm_virtual_network spoke {
	name 				= "${var.resource_group.name}-vnet"
	resource_group_name = var.resource_group.name
	location 			= var.resource_group.location
	address_space       = [var.vnet_address_space]
}

resource azurerm_virtual_network_peering spoketohub {
	name				= "${var.location}SpokeToHub"
	resource_group_name = var.resource_group.name
	virtual_network_name = azurerm_virtual_network.spoke.name
	remote_virtual_network_id = var.hub_vnet.id
	use_remote_gateways = false
}

resource azurerm_virtual_network_peering hubtospoke {
	name				= "hubToSpoke${var.location}"
	resource_group_name = var.hub_vnet.resource_group_name
	virtual_network_name = var.hub_vnet.name
	remote_virtual_network_id = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_zone" "spoke" {
  name = "${var.location}.${var.domain}"
  resource_group_name = var.resource_group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoke" {
	name                  = "${azurerm_private_dns_zone.spoke.name}-spoke-link"
	resource_group_name   = var.resource_group.name
	private_dns_zone_name = azurerm_private_dns_zone.spoke.name
	virtual_network_id    = azurerm_virtual_network.spoke.id
	registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "spoketohub" {
	name                  = "${var.hub_zone.name}-spoke-${var.location}-to-hub-link"
	resource_group_name   = var.hub_zone.resource_group_name
	private_dns_zone_name = var.hub_zone.name
	virtual_network_id    = azurerm_virtual_network.spoke.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "hubtospoke" {
	name                  = "${azurerm_private_dns_zone.spoke.name}-hub-to-spoke-${var.location}-link"
	resource_group_name   = azurerm_private_dns_zone.spoke.resource_group_name
	private_dns_zone_name = azurerm_private_dns_zone.spoke.name
	virtual_network_id    = var.hub_vnet.id
}

output "vnet" {
  value = azurerm_virtual_network.spoke
}

output "zone" {
	value = azurerm_private_dns_zone.spoke
}