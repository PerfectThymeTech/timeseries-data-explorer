locals {
  prefix = "${lower(var.prefix)}-${var.environment}"

  # Resource providers to register
  resource_providers_to_register = [
    "Microsoft.Authorization",
    "Microsoft.DataFactory",
    "Microsoft.EventGrid",
    "Microsoft.Insights",
    "Microsoft.KeyVault",
    "Microsoft.Kusto",
    "Microsoft.Management",
    "Microsoft.Network",
    "Microsoft.OperationsManagement",
    "Microsoft.OperationalInsights",
    "Microsoft.Resources",
    "Microsoft.Storage",
    "Microsoft.Security",
    "Microsoft.SecurityInsights",
  ]

  default_template_variables = {
    data_factory_name              = azurerm_data_factory.data_factory.name
    key_vault_uri                  = azurerm_key_vault.key_vault.vault_uri
    kusto_cluster_uri              = azurerm_kusto_cluster.kusto_cluster.uri
    datalake_id                    = azurerm_storage_account.storage.id
    datalake_primary_blob_endpoint = azurerm_storage_account.storage.primary_blob_endpoint
    datalake_primary_dfs_endpoint  = azurerm_storage_account.storage.primary_dfs_endpoint
  }
  data_factory_published_content_template_variables = merge(local.default_template_variables, var.data_factory_published_content_template_variables)

  # virtual_network = {
  #   resource_group_name = split("/", var.vnet_id)[4]
  #   name                = split("/", var.vnet_id)[8]
  # }

  # network_security_group = {
  #   resource_group_name = split("/", var.nsg_id)[4]
  #   name                = split("/", var.nsg_id)[8]
  # }

  # route_table = {
  #   resource_group_name = split("/", var.route_table_id)[4]
  #   name                = split("/", var.route_table_id)[8]
  # }
}
