resource azurerm_resource_group hub{
  name = "${local.prefix}-hub"
  location = var.location
}

resource azurerm_virtual_network hub {
	name                = "hub-vnet"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = ["10.1.0.0/16"]
  dns_servers         = ["10.1.2.4", "10.1.2.5", "10.1.2.6", "168.63.129.16"] 
}

resource azurerm_subnet firewall {
  name = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource azurerm_subnet vpngateway {
  name = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource azurerm_subnet dns {
  name = "DNSSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.1.2.0/29"]
}
resource azurerm_subnet jumpbox {
  name = "JumpboxSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.1.255.248/29"]
}


resource "azurerm_private_dns_zone" "hub" {
  name = "hub.${var.domain}"
  resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "hub" {
	name                  = "${azurerm_private_dns_zone.hub.name}-hub-link"
	resource_group_name   = azurerm_resource_group.hub.name
	private_dns_zone_name = azurerm_private_dns_zone.hub.name
	virtual_network_id    = azurerm_virtual_network.hub.id
	registration_enabled  = true
}

output "vnet" {
  value = azurerm_virtual_network.hub
}

output "prefix" {
  value = local.prefix
}

output "domain" {
  value = var.domain
}

output "zone" {
  value = azurerm_private_dns_zone.hub
}