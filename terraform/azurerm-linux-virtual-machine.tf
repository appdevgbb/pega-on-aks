# resource "azurerm_public_ip" "jumpbox001" {
#   name                = "${local.prefix}-jumpbox"
#   resource_group_name = azurerm_resource_group.pega.name
#   location            = azurerm_resource_group.pega.location
#   allocation_method   = "Static"
#   domain_name_label = "${local.prefix}-jumpbox"
# }

resource "azurerm_network_interface" "jumpbox001" {
  name                = "${local.prefix}-jumpbox"
  location            = azurerm_resource_group.pega.location
  resource_group_name = azurerm_resource_group.pega.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jumpbox.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = azurerm_public_ip.jumpbox001.id
  }
}

resource "azurerm_linux_virtual_machine" "jumpbox001" {
  name                = "${local.prefix}-jumpbox"
  resource_group_name = azurerm_resource_group.pega.name
  location            = azurerm_resource_group.pega.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = local.master_password
  disable_password_authentication = false

  custom_data = base64encode(templatefile("${path.module}/templates/jumpbox/cloud-init.yaml", {}))

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.example.public_key_openssh
  }

  network_interface_ids = [
    azurerm_network_interface.jumpbox001.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}