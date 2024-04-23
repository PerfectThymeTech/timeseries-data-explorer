# resource "azurerm_data_factory_managed_private_endpoint" "data_factory_managed_private_endpoint_storage_blob" {
#   name            = "AzureStorageBlob"
#   data_factory_id = azurerm_data_factory.data_factory.id

#   subresource_name   = "blob"
#   target_resource_id = azurerm_storage_account.storage.id
# }

# resource "null_resource" "data_factory_managed_private_endpoint_storage_blob_approval" {
#   triggers = {
#     run_once = "true"
#   }
#   provisioner "local-exec" {
#     working_dir = "${path.module}/../scripts/"
#     interpreter = ["pwsh", "-Command"]
#     command     = "./Approve-ManagedPrivateEndpoint.ps1 -ResourceId '${azurerm_storage_account.storage.id}' -WorkspaceName '${azurerm_data_factory.data_factory.name}' -ManagedPrivateEndpointName '${azurerm_data_factory_managed_private_endpoint.data_factory_managed_private_endpoint_storage_blob.name}'"
#   }
# }

# resource "azurerm_data_factory_managed_private_endpoint" "data_factory_managed_private_endpoint_storage_dfs" {
#   name            = "AzureStorageDfs"
#   data_factory_id = azurerm_data_factory.data_factory.id

#   subresource_name   = "dfs"
#   target_resource_id = azurerm_storage_account.storage.id
# }

# resource "null_resource" "data_factory_managed_private_endpoint_storage_dfs_approval" {
#   triggers = {
#     run_once = "true"
#   }
#   provisioner "local-exec" {
#     working_dir = "${path.module}/../scripts/"
#     interpreter = ["pwsh", "-Command"]
#     command     = "./Approve-ManagedPrivateEndpoint.ps1 -ResourceId '${azurerm_storage_account.storage.id}' -WorkspaceName '${azurerm_data_factory.data_factory.name}' -ManagedPrivateEndpointName '${azurerm_data_factory_managed_private_endpoint.data_factory_managed_private_endpoint_storage_dfs.name}'"
#   }
# }

# resource "azurerm_data_factory_managed_private_endpoint" "data_factory_managed_private_endpoint_key_vault" {
#   name            = "AzureKeyVault"
#   data_factory_id = azurerm_data_factory.data_factory.id

#   subresource_name   = "vault"
#   target_resource_id = azurerm_key_vault.key_vault.id
# }

# resource "null_resource" "data_factory_managed_private_endpoint_key_vault_approval" {
#   triggers = {
#     run_once = "true"
#   }
#   provisioner "local-exec" {
#     working_dir = "${path.module}/../scripts/"
#     interpreter = ["pwsh", "-Command"]
#     command     = "./Approve-ManagedPrivateEndpoint.ps1 -ResourceId '${azurerm_key_vault.key_vault.id}' -WorkspaceName '${azurerm_data_factory.data_factory.name}' -ManagedPrivateEndpointName '${azurerm_data_factory_managed_private_endpoint.data_factory_managed_private_endpoint_key_vault.name}'"
#   }
# }

resource "azurerm_data_factory_managed_private_endpoint" "data_factory_managed_private_endpoint_kusto_cluster" {
  name            = "AzureDataExplorer"
  data_factory_id = azurerm_data_factory.data_factory.id

  subresource_name   = "cluster"
  target_resource_id = azurerm_kusto_cluster.kusto_cluster.id
}

resource "null_resource" "data_factory_managed_private_endpoint_kusto_cluster_approval" {
  triggers = {
    run_once = "true"
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/../scripts/"
    interpreter = ["pwsh", "-Command"]
    command     = "./Approve-ManagedPrivateEndpoint.ps1 -ResourceId '${azurerm_kusto_cluster.kusto_cluster.id}' -WorkspaceName '${azurerm_data_factory.data_factory.name}' -ManagedPrivateEndpointName '${azurerm_data_factory_managed_private_endpoint.data_factory_managed_private_endpoint_kusto_cluster.name}'"
  }
}
