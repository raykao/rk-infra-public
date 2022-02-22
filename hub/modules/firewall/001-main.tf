locals {
  prefix = var.prefix
  workspace = terraform.workspace
  firewall_name = "${local.prefix}${local.workspace}"
}