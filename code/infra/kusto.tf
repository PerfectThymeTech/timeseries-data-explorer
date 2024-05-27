resource "azurerm_kusto_cluster" "kusto_cluster" {
  name                = "${local.prefix}-kusto001"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_dataeng.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }
  sku {
    name     = var.kusto_cluster_sku.name
    capacity = var.kusto_cluster_sku.capacity
  }
  zones = [
    1,
    2,
    3
  ]

  allowed_fqdns                      = []
  allowed_ip_ranges                  = []
  auto_stop_enabled                  = var.kusto_cluster_auto_stop_enabled
  disk_encryption_enabled            = true
  double_encryption_enabled          = true
  language_extensions                = var.kusto_cluster_language_extensions
  outbound_network_access_restricted = true
  # optimized_auto_scale {
  #   minimum_instances =
  #   maximum_instances =
  # }
  public_ip_type                = "IPv4"
  public_network_access_enabled = true # TODO: Update for prod deployment
  purge_enabled                 = var.kusto_cluster_purge_enabled
  streaming_ingestion_enabled   = var.kusto_cluster_streaming_ingestion_enabled
  trusted_external_tenants      = []
}

resource "azurerm_kusto_database" "kusto_database" {
  for_each = var.kusto_cluster_databases

  name                = each.key
  resource_group_name = azurerm_kusto_cluster.kusto_cluster.resource_group_name
  location            = azurerm_kusto_cluster.kusto_cluster.location
  cluster_name        = azurerm_kusto_cluster.kusto_cluster.name

  hot_cache_period   = each.value.hot_cache_period
  soft_delete_period = each.value.soft_delete_period

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "time_sleep" "sleep_kusto_db" {
  for_each = var.kusto_cluster_databases

  create_duration = "240s"
}

resource "azurerm_kusto_script" "kusto_script" {
  for_each = var.kusto_cluster_databases

  name        = "init-db-${each.key}"
  database_id = azurerm_kusto_database.kusto_database[each.key].id

  continue_on_errors_enabled         = false
  force_an_update_when_value_changed = filebase64(each.value.init_script)
  script_content                     = file(each.value.init_script)
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_kusto_cluster" {
  resource_id = azurerm_kusto_cluster.kusto_cluster.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_kusto_cluster" {
  for_each = { for index, value in var.diagnostics_configurations :
    index => {
      log_analytics_workspace_id = value.log_analytics_workspace_id,
      storage_account_id         = value.storage_account_id
    }
  }

  name                       = "applicationLogs-${each.key}"
  target_resource_id         = azurerm_kusto_cluster.kusto_cluster.id
  log_analytics_workspace_id = each.value.log_analytics_workspace_id == "" ? null : each.value.log_analytics_workspace_id
  storage_account_id         = each.value.storage_account_id == "" ? null : each.value.storage_account_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_kusto_cluster.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_kusto_cluster.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

# resource "azurerm_private_endpoint" "private_endpoint_kusto_cluster" {
#   name                = "${azurerm_kusto_cluster.kusto_cluster.name}-pe"
#   location            = var.location
#   resource_group_name = azurerm_kusto_cluster.kusto_cluster.resource_group_name
#   tags                = var.tags

#   custom_network_interface_name = "${azurerm_kusto_cluster.kusto_cluster.name}-nic"
#   private_service_connection {
#     name                           = "${azurerm_kusto_cluster.kusto_cluster.name}-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_kusto_cluster.kusto_cluster.id
#     subresource_names              = ["cluster"]
#   }
#   subnet_id = azapi_resource.subnet_services.id

#   lifecycle {
#     ignore_changes = [
#       private_dns_zone_group
#     ]
#   }
# }

# resource "time_sleep" "sleep_kusto_cluster" {
#   create_duration = "${var.connectivity_delay_in_seconds}s"

#   depends_on = [
#     azurerm_private_endpoint.private_endpoint_kusto_cluster
#   ]
# }
