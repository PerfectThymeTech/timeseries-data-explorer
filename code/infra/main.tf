resource "azurerm_resource_group" "resource_group_storage" {
  name     = "${local.prefix}-stg-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_resource_group" "resource_group_dataeng" {
  name     = "${local.prefix}-dataeng-rg"
  location = var.location
  tags     = var.tags
}
