resource "azurerm_storage_account" "storage" {
  name                = replace("${local.prefix}-stg001", "-", "")
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_storage.name
  tags                = var.tags

  access_tier                     = "Hot"
  account_kind                    = "StorageV2"
  account_replication_type        = "ZRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  allowed_copy_scope              = "AAD"
  blob_properties {
    change_feed_enabled = false
    container_delete_retention_policy {
      days = 7
    }
    delete_retention_policy {
      days = 7
    }
    default_service_version  = "2020-06-12"
    last_access_time_enabled = false
    versioning_enabled       = false
  }
  cross_tenant_replication_enabled  = false
  default_to_oauth_authentication   = true
  enable_https_traffic_only         = true
  infrastructure_encryption_enabled = true
  is_hns_enabled                    = true
  large_file_share_enabled          = false
  min_tls_version                   = "TLS1_2"
  network_rules {
    bypass                     = ["None"]
    default_action             = "Allow" # TODO: Update for prod deployment
    ip_rules                   = []
    virtual_network_subnet_ids = []
    private_link_access {
      endpoint_resource_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Security/datascanners/storageDataScanner"
      endpoint_tenant_id   = data.azurerm_client_config.current.tenant_id
    }
  }
  nfsv3_enabled                 = false
  public_network_access_enabled = true
  queue_encryption_key_type     = "Account"
  table_encryption_key_type     = "Account"
  routing {
    choice                      = "MicrosoftRouting"
    publish_internet_endpoints  = false
    publish_microsoft_endpoints = false
  }
  sftp_enabled              = false
  shared_access_key_enabled = false
}

resource "azurerm_storage_container" "storage_container" {
  for_each = var.storage_container_names

  name                 = each.key
  storage_account_name = azurerm_storage_account.storage.name

  container_access_type             = "private"
  encryption_scope_override_enabled = true
  metadata                          = {}
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_storage" {
  resource_id = azurerm_storage_account.storage.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_storage" {
  for_each = { for index, value in var.diagnostics_configurations :
    index => {
      log_analytics_workspace_id = value.log_analytics_workspace_id,
      storage_account_id         = value.storage_account_id
    }
  }

  name                       = "applicationLogs-${each.key}"
  target_resource_id         = azurerm_storage_account.storage.id
  log_analytics_workspace_id = each.value.log_analytics_workspace_id == "" ? null : each.value.log_analytics_workspace_id
  storage_account_id         = each.value.storage_account_id == "" ? null : each.value.storage_account_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_storage.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_storage.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

# resource "azurerm_private_endpoint" "storage_private_endpoint_blob" {
#   name                = "${azurerm_storage_account.storage.name}-blob-pe"
#   location            = var.location
#   resource_group_name = azurerm_storage_account.storage.resource_group_name
#   tags                = var.tags

#   custom_network_interface_name = "${azurerm_storage_account.storage.name}-blob-nic"
#   private_service_connection {
#     name                           = "${azurerm_storage_account.storage.name}-blob-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_storage_account.storage.id
#     subresource_names              = ["blob"]
#   }
#   subnet_id = azapi_resource.subnet_services.id

#   lifecycle {
#     ignore_changes = [
#       private_dns_zone_group
#     ]
#   }
# }

# resource "azurerm_private_endpoint" "storage_private_endpoint_dfs" {
#   name                = "${azurerm_storage_account.storage.name}-dfs-pe"
#   location            = var.location
#   resource_group_name = azurerm_storage_account.storage.resource_group_name
#   tags                = var.tags

#   custom_network_interface_name = "${azurerm_storage_account.storage.name}-dfs-nic"
#   private_service_connection {
#     name                           = "${azurerm_storage_account.storage.name}-dfs-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_storage_account.storage.id
#     subresource_names              = ["dfs"]
#   }
#   subnet_id = azapi_resource.subnet_services.id

#   lifecycle {
#     ignore_changes = [
#       private_dns_zone_group
#     ]
#   }
# }
