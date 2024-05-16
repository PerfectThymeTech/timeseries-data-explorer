# Timeseries Data Explorer

## Instructions for deployment

### Prerequisites

Install the following tools on your device:

- Azure CLI
- Azure Subscription
- Terraform

### Azure CLI configuration

Configure Azure CLI on your device by runnin the follwing commands:

```sh
# Login to Azure
az login

# Set azure account
az account set --subscription "<your-subscription-id>"

# Configure CLI
az config set extension.use_dynamic_install=yes_without_prompt
```

### Update Variables

Open the [`code\infra\vars.tfvars`](code\infra\vars.tfvars) file and update the prefix and location parameters:

```hcl
location    = "<your-location>"
environment = "dev"
prefix      = "<your-prefix-value>"
tags        = {}
...
```

### Terraform deployment (local backend)

Deploy the Terraform configuration using the following commands:

```sh
# Move terraform_override.tf file
move .\utilities\terraformConfigSamples\* .\code\infra\

# Change directory
cd .\code\infra\

# Terraform init
terraform init

# Terraform plan
terraform plan -var-file="vars.tfvars"

# Terraform apply
terraform apply -var-file="vars.tfvars"
```

You successfully deployed the setup!
