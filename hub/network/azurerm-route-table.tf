resource "azurerm_route_table" "hub" {
  depends_on = [
    module.firewall
  ]
  
  name                = "hubRouteTable"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
}

resource "azurerm_route" "hub" {
  name                = "hubRoute"
  resource_group_name = azurerm_resource_group.hub.name
  route_table_name    = azurerm_route_table.hub.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = module.firewall.ip_address
}

# resource "azurerm_subnet_route_table_association" "jumpbox" {
#   subnet_id      = azurerm_subnet.jumpbox.id
#   route_table_id = azurerm_route_table.hub.id
# }

resource "azurerm_subnet_route_table_association" "dns" {
  subnet_id      = azurerm_subnet.dns.id
  route_table_id = azurerm_route_table.hub.id
}

# resource "azurerm_subnet_route_table_association" "aks" {
#   subnet_id      = azurerm_subnet.aks.id
#   route_table_id = azurerm_route_table.hub.id
# }
