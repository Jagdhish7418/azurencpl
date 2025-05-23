resource "azurerm_key_vault" "keyvault" {
  name                        = "bcp3-keyvault"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", 
      "List",
      "Create",
      "Update",
      "Delete",
      "Purge",
    ]

    secret_permissions = [
      "Get",
      "Set",
      "List",
      "Backup",
      "Delete",
      "Restore",
       "Purge",
    ]


  }

}

resource "azurerm_key_vault_secret" "key" {
  name         = "secret-sauce"
  key_vault_id = azurerm_key_vault.keyvault.id
  value = var.dbpassword
}
