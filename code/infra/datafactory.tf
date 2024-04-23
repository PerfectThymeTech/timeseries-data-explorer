resource "azurerm_data_factory" "data_factory" {
  name                = "${local.prefix}-df001"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_dataeng.name
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }

  managed_virtual_network_enabled = true
  public_network_enabled          = true # TODO: Update for prod deployment

  dynamic "global_parameter" {
    for_each = var.data_factory_global_parameters
    content {
      name  = each.key
      type  = each.value.type
      value = each.value.value
    }
  }
  dynamic "vsts_configuration" {
    for_each = length(compact(values(var.data_factory_azure_devops_repo))) == 6 ? [var.data_factory_azure_devops_repo] : []
    content {
      account_name    = azure_devops_repo.value["account_name"]
      branch_name     = azure_devops_repo.value["branch_name"]
      project_name    = azure_devops_repo.value["project_name"]
      repository_name = azure_devops_repo.value["repository_name"]
      root_folder     = azure_devops_repo.value["root_folder"]
      tenant_id       = azure_devops_repo.value["tenant_id"]
    }
  }
}

data "azurerm_monitor_diagnostic_categories" "diagnostic_categories_data_factory" {
  resource_id = azurerm_data_factory.data_factory.id
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_data_factory" {
  for_each = { for index, value in var.diagnostics_configurations :
    index => {
      log_analytics_workspace_id = value.log_analytics_workspace_id,
      storage_account_id         = value.storage_account_id
    }
  }

  name                       = "applicationLogs-${each.key}"
  target_resource_id         = azurerm_data_factory.data_factory.id
  log_analytics_workspace_id = each.value.log_analytics_workspace_id == "" ? null : each.value.log_analytics_workspace_id
  storage_account_id         = each.value.storage_account_id == "" ? null : each.value.storage_account_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_data_factory.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_data_factory.metrics
    content {
      category = entry.value
      enabled  = true
    }
  }
}

# resource "azurerm_private_endpoint" "private_endpoint_data_factory" {
#   name                = "${azurerm_data_factory.data_factory.name}-pe"
#   location            = var.location
#   resource_group_name = azurerm_data_factory.data_factory.resource_group_name
#   tags                = var.tags

#   custom_network_interface_name = "${azurerm_data_factory.data_factory.name}-nic"
#   private_service_connection {
#     name                           = "${azurerm_data_factory.data_factory.name}-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_data_factory.data_factory.id
#     subresource_names              = ["vault"]
#   }
#   subnet_id = azapi_resource.subnet_services.id

#   lifecycle {
#     ignore_changes = [
#       private_dns_zone_group
#     ]
#   }
# }

# resource "time_sleep" "sleep_data_factory" {
#   create_duration = "${var.connectivity_delay_in_seconds}s"

#   depends_on = [
#     azurerm_private_endpoint.private_endpoint_data_factory
#   ]
# }
