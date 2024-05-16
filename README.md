# Timeseries Data Explorer

## Instructions for deployment

### Prerequisites

- Azure CLI
- Azure Subscription
- Terraform

### Azure CLI configuration

```sh
# Login to Azure
az login

# Set azure account
az account set --subscription "<your-subscription-id>"

# Configure CLI
az config set extension.use_dynamic_install=yes_without_prompt
```

### Terraform deployment (local backend)

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
