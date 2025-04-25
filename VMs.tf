# Create a virtual machine01 (VM) and attach it to the NICVM01
resource "azurerm_linux_virtual_machine" "webvm" {
name                = "bcp3-webvm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.webvmnic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("${path.module}/ssh-key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version = "latest"
}
custom_data = filebase64("webinit.sh")
}



# Create a virtual machine (VM02) and attach it to the NICVM02
resource "azurerm_virtual_machine" "appvm" {
  name                  = "bcp3-appvm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.appvmnic.id]
  vm_size               = "Standard_B1s"  # Define VM size

  # Specify the OS image to use
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # Define OS disk settings
  storage_os_disk {
    name              = "bcp3-os-appvm"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Configure VM login credentials
  os_profile {
    computer_name  = "bcp3appvm"
    admin_username = "azureuser"
    admin_password = azurerm_key_vault_secret.key.value  # Replace with a secure password
  }

  # Enable password authentication for Linux VM
  os_profile_linux_config {
    disable_password_authentication=false
}
}

#Extension for VM01

/* resource "azurerm_virtual_machine_extension" "install_nginxwebvm" {
  name = "InstallNginxwebvm"
  virtual_machine_id = azurerm_virtual_machine.webvm.id
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
{
"commandToExecute": "sudo apt-get update -y && sudo apt-get install -y nginx && echo '<h1>Welcome to My Terraform Deployed Website Hosted by VM01</h1>' | sudo tee /var/www/html/index.html"
}

SETTINGS

}
 */
#Extension for VM02

resource "azurerm_virtual_machine_extension" "install_nginxappvm" {
  name = "InstallNginxappvm"
  virtual_machine_id = azurerm_virtual_machine.appvm.id
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
{
"commandToExecute": "sudo apt-get update -y && sudo apt-get install -y nginx && echo '<h1>Welcome to My Terraform Deployed Website Hosted by VM02</h1>' | sudo tee /var/www/html/index.html"
}

SETTINGS

}

