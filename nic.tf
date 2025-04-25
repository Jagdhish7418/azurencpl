#Create NIC for Web VM

# Create a network interface (NIC) for webvm and associate it with the subnet
resource "azurerm_network_interface" "webvmnic" {
  name                = "bcp3-webvmnic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal-web"
    subnet_id                     = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
    
  }
}

# Create a network interface (NIC) for appvm and associate it with the subnet
resource "azurerm_network_interface" "appvmnic" {
  name                = "bcp3-appvmnic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal-app"
    subnet_id                     = azurerm_subnet.appsubnet.id
    private_ip_address_allocation = "Dynamic"
    
  }
}
