resource "azurerm_key_vault" "key_vault" {
  name                = "${local.prefix}-vault001"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_dataeng.name
  tags                = var.tags

  access_policy                   = []
  enable_rbac_authorization       = true
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow" # TODO: Update for prod deployment
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  public_network_access_enabled = true # TODO: Update for prod deployment
  purge_protection_enabled      = true
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  tenant_id                     = data.azurerm_client_config.current.tenant_id
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_key_vault" {
  resource_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_key_vault" {
  for_each = { for index, value in var.diagnostics_configurations :
    index => {
      log_analytics_workspace_id = value.log_analytics_workspace_id,
      storage_account_id         = value.storage_account_id
    }
  }

  name                       = "applicationLogs-${each.key}"
  target_resource_id         = azurerm_key_vault.key_vault.id
  log_analytics_workspace_id = each.value.log_analytics_workspace_id == "" ? null : each.value.log_analytics_workspace_id
  storage_account_id         = each.value.storage_account_id == "" ? null : each.value.storage_account_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_key_vault.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_key_vault.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

# resource "azurerm_private_endpoint" "private_endpoint_key_vault" {
#   name                = "${azurerm_key_vault.key_vault.name}-pe"
#   location            = var.location
#   resource_group_name = azurerm_key_vault.key_vault.resource_group_name
#   tags                = var.tags

#   custom_network_interface_name = "${azurerm_key_vault.key_vault.name}-nic"
#   private_service_connection {
#     name                           = "${azurerm_key_vault.key_vault.name}-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_key_vault.key_vault.id
#     subresource_names              = ["vault"]
#   }
#   subnet_id = azapi_resource.subnet_services.id

#   lifecycle {
#     ignore_changes = [
#       private_dns_zone_group
#     ]
#   }
# }

# resource "time_sleep" "sleep_key_vault" {
#   create_duration = "${var.connectivity_delay_in_seconds}s"

#   depends_on = [
#     azurerm_private_endpoint.private_endpoint_key_vault
#   ]
# }
