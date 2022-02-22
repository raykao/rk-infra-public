variable "prefix" {
  type = string
}

variable "resource_group" {
}

variable "subnet_id" {
}

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

locals {
	prefix = var.prefix
}

module "jumpbox" {
	source = "../main../modules/jumpbox"

	prefix = local.prefix
	
	subnet_id = var.subnet_id
	resource_group = var.resource_group
}


# resource "azurerm_firewall_nat_rule_collection" "ssh" {
#   name                = "JumpboxSSHDnatRule"
#   azure_firewall_name = var.firewall_name
#   resource_group_name = var.resource_group.name
#   priority            = 200
#   action              = "Dnat"

#   rule {
#     name = "JumpboxSSH"

#     source_addresses = [
#       "*"
#     ]

#     destination_ports = [
#       "2202"
#     ]

#     destination_addresses = [
#       module.firewall.public_ip_address
#     ]

#     translated_port = 22

#     translated_address = module.jumpbox.ip_address

#     protocols = [
#       "TCP"
#     ]
#   }
# }