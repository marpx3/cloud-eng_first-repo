terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstate4257"
    container_name       = "tfstate"
    key                  = "projekt-04.tfstate"
  }
}

provider "azurerm" {
  features {}
}

