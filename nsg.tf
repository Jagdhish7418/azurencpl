# Create a Network Security Gateway for webvm
resource "azurerm_network_security_group" "nsgwebvm" {
  name = "bcp3-nsgwebvm"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name = "Allow-SSH"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name = "Allow-HTTP"
    priority = 101
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgawebsubnet" {
 subnet_id = azurerm_subnet.websubnet.id
 network_security_group_id = azurerm_network_security_group.nsgwebvm.id
 depends_on = [ azurerm_resource_group.rg ]
}

# Create a Network Security Gateway for appvm
resource "azurerm_network_security_group" "nsgappvm" {
  name = "bcp3-nsgappvm"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name = "Allow-HTTP"
    priority = 102
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "80"
    source_address_prefix = azurerm_subnet.websubnet.address_prefixes[0]
    destination_address_prefix = "*"
  }

  security_rule {
    name = "Allow-db"
    priority = 103
    direction = "Outbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3306"
    source_address_prefix = azurerm_subnet.appsubnet.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.dbsubnet.address_prefixes[0]
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgaappsubnet" {
 subnet_id = azurerm_subnet.appsubnet.id
 network_security_group_id = azurerm_network_security_group.nsgappvm.id
 depends_on = [ azurerm_resource_group.rg ]
}

resource "azurerm_network_security_group" "dbnsg" {
  name = "bcp3-nsgdb"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name = "Allow-HTTP"
    priority = 104
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_port_range = "*"
    destination_port_range = "3306"
    source_address_prefix = azurerm_subnet.appsubnet.address_prefixes[0]
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "nsgadb" {
 subnet_id = azurerm_subnet.dbsubnet.id
 network_security_group_id = azurerm_network_security_group.dbnsg.id
 depends_on = [ azurerm_resource_group.rg ]
}