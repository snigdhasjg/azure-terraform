terraform {
  required_providers {
    azurerm = {
      version = "~> 3.71.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true

  features {}
}