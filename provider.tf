provider "azurerm" {
  subscription_id = "77a447e1-3eff-4cdc-8d0f-48f2ccd70119"
  features {}
}

data "azurerm_client_config" "current" {}