resource "azurerm_resource_group_template_deployment" "data_factory_content_deployment" {
  count = var.data_factory_published_content != {} ? [1] : []

  name                = "dataFactoryContentDeployment"
  resource_group_name = azurerm_data_factory.data_factory.resource_group_name
  tags                = var.tags

  debug_level        = "none"
  deployment_mode    = "Incremental"
  parameters_content = data.local_file.data_factory_parameters_file
  template_content   = data.local_file.data_factory_template_file
}
