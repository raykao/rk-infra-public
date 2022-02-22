terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "~> 2.65.0"
		}
	}
}

provider azurerm {
	features {}
}

variable "location" {
  type = string
}

variable "vnet_address_space" {
  type = string
}


data "terraform_remote_state" "hub" {
  backend = "local"
  config = {
    path = "${path.module}/../../../hub/network/terraform.tfstate"
  }
}

locals {
  hub = data.terraform_remote_state.hub.outputs
}

resource azurerm_resource_group spoke {
  name = "${local.hub.prefix}-spoke-001"
  location = var.location
}

module "network" {
  source = "../../modules/networking"
  resource_group = azurerm_resource_group.spoke
  location = var.location
  prefix = local.hub.prefix
  domain = local.hub.domain
  vnet_address_space = var.vnet_address_space
  hub_vnet = local.hub.vnet
  hub_zone = local.hub.zone
}

resource "azurerm_subnet" "appgw" {
  name                 = "AppGWSubnet"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = module.network.vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_address_space, 8, 0)]
}

resource "azurerm_subnet" "jumpbox" {
  name                 = "JumpboxSubnet"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = module.network.vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_address_space, 8, 1)]
}

resource "azurerm_subnet" "aks001" {
  name                 = "Aks001Subnet"
  resource_group_name  = azurerm_resource_group.spoke.name
  virtual_network_name = module.network.vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_address_space, 6, 1)]
}

output vnet {
  value = module.network.vnet
}

output zone {
  value = module.network.zone
}