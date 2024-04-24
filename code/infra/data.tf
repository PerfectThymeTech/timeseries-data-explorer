data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "azurerm_location" "current" {
  location = var.location
}

data "local_file" "data_factory_parameters_file" {
  count = var.data_factory_published_content != {} ? [1] : []

  filename = var.data_factory_published_content.parameters_file
}

data "local_file" "data_factory_template_file" {
  count = var.data_factory_published_content != {} ? [1] : []

  filename = var.data_factory_published_content.template_file
}

# data "azurerm_virtual_network" "virtual_network" {
#   name                = local.virtual_network.name
#   resource_group_name = local.virtual_network.resource_group_name
# }

# data "azurerm_network_security_group" "network_security_group" {
#   name                = local.network_security_group.name
#   resource_group_name = local.network_security_group.resource_group_name
# }

# data "azurerm_route_table" "route_table" {
#   name                = local.route_table.name
#   resource_group_name = local.route_table.resource_group_name
# }
