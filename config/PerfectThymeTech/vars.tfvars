location    = "germanywestcentral"
environment = "int"
prefix      = "sc4"
tags        = {}

# Service variables
data_factory_azure_devops_repo = {}
data_factory_global_parameters = {}
kusto_cluster_sku = {
  name     = "Standard_E2ads_v5",
  capacity = 2
}
kusto_cluster_language_extensions         = ["PYTHON_3.10.8"]
kusto_cluster_auto_stop_enabled           = false
kusto_cluster_purge_enabled               = false
kusto_cluster_streaming_ingestion_enabled = false
kusto_cluster_databases = {
  operationaldb = {
    hot_cache_period   = "P7D"
    soft_delete_period = "P31D"
  }
}

# Monitoring variables
diagnostics_configurations = []
