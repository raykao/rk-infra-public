resource "azurerm_virtual_network" "default" {
  name = "${azurerm_resource_group.default.name}-vnet"
  location = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.255.0.0/16"]
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.255.0.0/26"]
}

resource "azurerm_subnet" "vpngateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.255.0.64/27"]
}

resource "azurerm_subnet" "vpngatewayclients" {
  name                 = "GatewayClientsSubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.255.0.96/27"]
}

resource "azurerm_subnet" "dnsForwarder" {
  name                 = "DnsForwarderSubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.255.0.128/29"]
}

resource "azurerm_subnet" "acr" {
  name                 = "AcrSubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  # service_endpoints     = ["Microsoft.ContainerRegistry"]
  # enforce_private_link_service_network_policies  = false
  enforce_private_link_endpoint_network_policies = true
  address_prefixes     = ["10.255.0.160/27"]
}

resource "azurerm_subnet" "aks" {
  name                 = "AksSubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  enforce_private_link_endpoint_network_policies = true
  address_prefixes     = ["10.255.4.0/22"]
}

resource "azurerm_subnet" "jumpbox" {
  name                 = "JumpboxSubnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.255.255.240/28"]
}