location    = "germanywestcentral"
environment = "dev"
prefix      = "sc4"
tags        = {}

# Service variables
data_factory_azure_devops_repo = {
  testkey = {
    type  = "String"
    value = "testvalue"
  }
}
data_factory_github_repo = {
  account_name    = "PerfectThymeTech"
  branch_name     = "main"
  git_url         = "https://github.com"
  repository_name = "timeseries-data-explorer"
  root_folder     = "/code/datafactory"
}
data_factory_global_parameters = {}
data_factory_published_content = {
  # parameters_file = "../sample/ARMTemplateParametersForFactory.json"
  # template_file   = "../sample/ARMTemplateForFactory.json"
}
data_factory_published_content_template_variables = {}
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
    init_script        = "../datamodel/operationaldb.kql"
  }
}
storage_container_names = ["upload-iptv", "upload-otv", "raw", "curated", "logs"]

# Monitoring variables
diagnostics_configurations = []
