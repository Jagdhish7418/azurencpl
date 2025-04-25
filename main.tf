# Create a resource group
resource "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "bcp3vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]  # Define the IP range for the VNet
}

# Create a subnet for Web tier within the virtual network
resource "azurerm_subnet" "websubnet" {
  name                 = "bcp3websubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]  # Define the IP range for the subnet
}

# Create a subnet for app tier within the virtual network
resource "azurerm_subnet" "appsubnet" {
  name                 = "bcp3appsubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]  # Define the IP range for the subnet
}

# Create a subnet for db tier within the virtual network
resource "azurerm_subnet" "dbsubnet" {
  name                 = "bcp3dbsubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]  # Define the IP range for the subnet

   service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
depends_on = [ azurerm_resource_group.rg]

}

# Create a subnet for appgateway tier within the virtual network
resource "azurerm_subnet" "appgatewaysubnet" {
  name                 = "bcp3appgatewaysubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]  # Define the IP range for the subnet
}

