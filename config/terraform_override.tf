terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.103.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.11.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
}
