# General variables
variable "location" {
  description = "Specifies the location for all Azure resources."
  type        = string
  sensitive   = false
}

variable "environment" {
  description = "Specifies the environment of the deployment."
  type        = string
  sensitive   = false
  default     = "dev"
  validation {
    condition     = contains(["int", "dev", "tst", "qa", "uat", "prd"], var.environment)
    error_message = "Please use an allowed value: \"int\", \"dev\", \"tst\", \"qa\", \"uat\" or \"prd\"."
  }
}

variable "prefix" {
  description = "Specifies the prefix for all resources created in this deployment."
  type        = string
  sensitive   = false
  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 10
    error_message = "Please specify a prefix with more than two and less than 10 characters."
  }
}

variable "tags" {
  description = "Specifies the tags that you want to apply to all resources."
  type        = map(string)
  sensitive   = false
  default     = {}
}

# Service variables
variable "data_factory_azure_devops_repo" {
  description = "Specifies the Azure Devops repository configuration."
  type = object(
    {
      account_name    = optional(string, "")
      branch_name     = optional(string, "")
      project_name    = optional(string, "")
      repository_name = optional(string, "")
      root_folder     = optional(string, "")
      tenant_id       = optional(string, "")
    }
  )
  sensitive = false
  nullable  = false
  default   = {}
}

variable "data_factory_github_repo" {
  description = "Specifies the Github repository configuration."
  type = object(
    {
      account_name    = optional(string, "")
      branch_name     = optional(string, "")
      git_url         = optional(string, "")
      repository_name = optional(string, "")
      root_folder     = optional(string, "")
    }
  )
  sensitive = false
  nullable  = false
  default   = {}
}

variable "data_factory_global_parameters" {
  description = "Specifies the Azure Data Factory global parameters."
  type = map(object({
    type  = optional(string, "String")
    value = optional(any, "")
  }))
  sensitive = false
  nullable  = false
  default   = {}
  validation {
    condition = alltrue([
      length([for type in values(var.data_factory_global_parameters)[*].type : type if !contains(["Array", "Bool", "Float", "Int", "Object", "String"], type)]) <= 0,
    ])
    error_message = "Please specify a valid global parameter configuration."
  }
}

variable "data_factory_published_content" {
  description = "Specifies the Azure Devops repository configuration."
  type = object(
    {
      parameters_file = optional(string, "")
      template_file   = optional(string, "")
    }
  )
  sensitive = false
  nullable  = false
  default   = {}
}

variable "data_factory_published_content_template_variables" {
  description = "Specifies custom template variables to use for the deployment templates from ADF."
  type        = map(string)
  sensitive   = false
  default     = {}
}

variable "kusto_cluster_sku" {
  description = "Specifies the kusto cluster sku name."
  type = object({
    name     = optional(string, "Dev(No SLA)_Standard_D11_v2"),
    capacity = optional(number, 1)
  })
  sensitive = false
  validation {
    condition = alltrue([
      # contains(["TODO"], var.kusto_cluster_sku.name),
      var.kusto_cluster_sku.capacity > 0,
    ])
    error_message = "Please specify a valid sku configuration."
  }
}

variable "kusto_cluster_language_extensions" {
  description = "Specifies the kusto cluster language extensions."
  type        = list(string)
  sensitive   = false
  default     = []
  validation {
    condition = alltrue([
      length([for kusto_cluster_language_extensions in toset(var.kusto_cluster_language_extensions) : kusto_cluster_language_extensions if !contains(["PYTHON", "PYTHON_3.10.8", "R"], kusto_cluster_language_extensions)]) <= 0
    ])
    error_message = "Please specify a valid language extension."
  }
}

variable "kusto_cluster_auto_stop_enabled" {
  description = "Specifies the kusto cluster auto stop configuration."
  type        = bool
  sensitive   = false
  default     = false
}

variable "kusto_cluster_purge_enabled" {
  description = "Specifies the kusto cluster purge configuration."
  type        = bool
  sensitive   = false
  default     = false
}

variable "kusto_cluster_streaming_ingestion_enabled" {
  description = "Specifies the kusto cluster streaming ingestion configuration."
  type        = bool
  sensitive   = false
  default     = false
}

variable "kusto_cluster_databases" {
  description = "Specifies the kusto cluster database names."
  type = map(object({
    hot_cache_period   = optional(string, "P7D"),
    soft_delete_period = optional(string, "P31D"),
  }))
  sensitive = false
  default   = {}
}

variable "storage_container_names" {
  description = "Specifies the names of the storage account containers."
  type        = list(string)
  sensitive   = false
  default     = []
}

# Monitoring variables
variable "diagnostics_configurations" {
  description = "Specifies the diagnostic configuration for the service."
  type = list(object({
    log_analytics_workspace_id = optional(string, ""),
    storage_account_id         = optional(string, "")
  }))
  sensitive = false
  default   = []
  validation {
    condition = alltrue([
      length([for diagnostics_configuration in toset(var.diagnostics_configurations) : diagnostics_configuration if diagnostics_configuration.log_analytics_workspace_id == "" && diagnostics_configuration.storage_account_id == ""]) <= 0
    ])
    error_message = "Please specify a valid resource ID for the log analytics workspace or storage account."
  }
}

# Network variables
# variable "vnet_id" {
#   description = "Specifies the resource ID of the Vnet used for the Azure Function."
#   type        = string
#   sensitive   = false
#   validation {
#     condition     = length(split("/", var.vnet_id)) == 9
#     error_message = "Please specify a valid resource ID."
#   }
# }

# variable "nsg_id" {
#   description = "Specifies the resource ID of the default network security group for the Azure Function."
#   type        = string
#   sensitive   = false
#   validation {
#     condition     = length(split("/", var.nsg_id)) == 9
#     error_message = "Please specify a valid resource ID."
#   }
# }

# variable "route_table_id" {
#   description = "Specifies the resource ID of the default route table for the Azure Function."
#   type        = string
#   sensitive   = false
#   validation {
#     condition     = length(split("/", var.route_table_id)) == 9
#     error_message = "Please specify a valid resource ID."
#   }
# }

# variable "connectivity_delay_in_seconds" {
#   description = "Specifies the delay in seconds after the private endpoint deployment (required for the DNS automation via Policies)."
#   type        = number
#   sensitive   = false
#   nullable    = false
#   default     = 120
#   validation {
#     condition     = var.connectivity_delay_in_seconds >= 0
#     error_message = "Please specify a valid non-negative number."
#   }
# }
