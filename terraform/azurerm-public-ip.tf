
resource "azurerm_public_ip" "pega" {
  name                = "pegaPublicIp1"
  resource_group_name = azurerm_resource_group.pega.name
  location            = azurerm_resource_group.pega.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label = local.prefix
}