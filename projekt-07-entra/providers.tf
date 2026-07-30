terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstate4257"
    container_name       = "tfstate"
    key                  = "projekt-07.tfstate"
  }
}

provider "azuread" {
}