module dns {
	source = "../modules/dnsForwarder"

	prefix = local.prefix
	vnet_address_spaces = azurerm_virtual_network.hub.address_space
	subnet_id = azurerm_subnet.dns.id
	resource_group = azurerm_resource_group.hub
}