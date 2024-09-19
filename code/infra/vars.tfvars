location    = "germanywestcentral"
environment = "dev"
prefix      = "mysc4"
tags        = {}

# Service variables
data_factory_azure_devops_repo = {}
data_factory_github_repo       = {}
data_factory_global_parameters = {
  happinessThreshold = {
    type  = "Float"
    value = "0.8"
  }
  movingWindowInMinutes = {
    type  = "Float"
    value = "30.0"
  }
  minimumNumberOfUsersPerWindow = {
    type  = "Float"
    value = "10.0"
  }
  minimumPlays = {
    type  = "Float"
    value = "20.0"
  }
  minimumLift = {
    type  = "Float"
    value = "5.0"
  }
  minimumUsersRatio = {
    type  = "Float"
    value = "0.1"
  }
}
data_factory_published_content = {
  parameters_file = "../../tsde-int-df001/ARMTemplateParametersForFactory.json"
  template_file   = "../../tsde-int-df001/ARMTemplateForFactory.json"
}
data_factory_published_content_template_variables = {}
data_factory_triggers_start = [
  "IptvUpload",
  "OttUpload",
  "Reference",
  "Kusto"
]
data_factory_pipelines_run = [
  "ReferenceMainPipeline"
]
kusto_cluster_sku = {
  name     = "Standard_E2ads_v5",
  capacity = 2
}
kusto_cluster_language_extensions = [
  {
    name  = "PYTHON"
    image = "Python3_10_8"
  }
]
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
storage_container_names = ["upload-iptv", "upload-ott", "raw", "curated", "logs"]

# Monitoring variables
diagnostics_configurations = []
