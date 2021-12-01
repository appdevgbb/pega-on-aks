resource "azurerm_container_registry" "pega" {
  name                     = replace(local.prefix, "-", "")
  resource_group_name      = azurerm_resource_group.pega.name
  location                 = azurerm_resource_group.pega.location
  sku                      = "Premium"
  admin_enabled            = true
}