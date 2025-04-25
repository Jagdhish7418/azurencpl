resource "azurerm_mysql_flexible_server" "sql_server" {
  name                   = "bcp3-mysqlflexisvr"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = "sqladminuser"
  administrator_password = azurerm_key_vault_secret.key.value
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.dbsubnet.id
  private_dns_zone_id    = null
  sku_name               = "B_Standard_B1ms"

  depends_on = [ azurerm_resource_group.rg ]
}
resource "azurerm_mysql_flexible_database" "sql_db" {
  name                = "userdetails"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.sql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

  depends_on = [ azurerm_mysql_flexible_server.sql_server]
}