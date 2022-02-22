data "azurerm_client_config" "current" {}

locals {
  prefix = var.prefix

  workspace = terraform.workspace

  hostname  = "${local.prefix}${local.workspace}"
  subnet_id = var.subnet_id
}