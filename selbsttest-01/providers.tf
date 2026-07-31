terraform {
  required_providers {

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstate4257"
    container_name       = "tfstate"
    key                  = "selbsttest-01.tfstate"
  }
}

provider "azuread" {
}

provider "azurerm" {
  features {}
}