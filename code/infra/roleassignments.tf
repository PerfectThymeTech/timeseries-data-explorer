# Current role assignments
resource "azurerm_role_assignment" "current_role_assignment_key_vault" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}
resource "azurerm_role_assignment" "current_role_assignment_storage" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Data Factory role assignments
resource "azurerm_role_assignment" "data_factory_role_assignment_key_vault" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_data_factory.data_factory.identity[0].principal_id
}

resource "azurerm_role_assignment" "data_factory_role_assignment_storage" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_data_factory.data_factory.identity[0].principal_id
}

resource "azurerm_kusto_database_principal_assignment" "data_factory_kusto_database_principal_assignment_ingestor" {
  for_each = var.kusto_cluster_databases

  name                = "${each.key}-Ingestor-${azurerm_data_factory.data_factory.name}"
  resource_group_name = azurerm_kusto_cluster.kusto_cluster.resource_group_name
  cluster_name        = azurerm_kusto_cluster.kusto_cluster.name
  database_name       = each.key

  principal_id   = azurerm_data_factory.data_factory.identity[0].principal_id
  principal_type = "App"
  role           = "Ingestor"
  tenant_id      = data.azurerm_client_config.current.tenant_id

  depends_on = [
    time_sleep.sleep_kusto_db
  ]
}

resource "azurerm_kusto_database_principal_assignment" "data_factory_kusto_database_principal_assignment_viewer" {
  for_each = var.kusto_cluster_databases

  name                = "${each.key}-Viewer-${azurerm_data_factory.data_factory.name}"
  resource_group_name = azurerm_kusto_cluster.kusto_cluster.resource_group_name
  cluster_name        = azurerm_kusto_cluster.kusto_cluster.name
  database_name       = each.key

  principal_id   = azurerm_data_factory.data_factory.identity[0].principal_id
  principal_type = "App"
  role           = "Viewer"
  tenant_id      = data.azurerm_client_config.current.tenant_id

  depends_on = [
    time_sleep.sleep_kusto_db
  ]
}

resource "azurerm_kusto_database_principal_assignment" "data_factory_kusto_database_principal_assignment_admin" {
  for_each = var.kusto_cluster_databases

  name                = "${each.key}-Admin-${azurerm_data_factory.data_factory.name}"
  resource_group_name = azurerm_kusto_cluster.kusto_cluster.resource_group_name
  cluster_name        = azurerm_kusto_cluster.kusto_cluster.name
  database_name       = each.key

  principal_id   = azurerm_data_factory.data_factory.identity[0].principal_id
  principal_type = "App"
  role           = "Admin"
  tenant_id      = data.azurerm_client_config.current.tenant_id

  depends_on = [
    time_sleep.sleep_kusto_db
  ]
}
