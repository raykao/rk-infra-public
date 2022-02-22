locals {
  prefix = var.prefix
  workspace = terraform.workspace
  hostname = "${local.prefix}${local.workspace}"
}