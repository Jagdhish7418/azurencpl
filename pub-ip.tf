#Create Pub-IP for App Gateway

resource "azurerm_public_ip" "pubipappgateway" {
  name = "bcp3pubip-appgatway"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Static"
  sku = "Standard"
}

