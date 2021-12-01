resource azurerm_virtual_network pega {
	name = "${local.prefix}-vnet"
	resource_group_name = azurerm_resource_group.pega.name
	location = azurerm_resource_group.pega.location

	address_space = [var.vnet_address_space]
}

resource azurerm_subnet firewall {
	name = "AzureFirewallSubnet"
	resource_group_name 	= azurerm_resource_group.pega.name
	virtual_network_name 	= azurerm_virtual_network.pega.name
	address_prefixes		= [var.azure_firewall_subnet_space]
}

resource azurerm_subnet loadbalancer {
	name = "loadbalancer-subnet"
	resource_group_name 	= azurerm_resource_group.pega.name
	virtual_network_name 	= azurerm_virtual_network.pega.name
	address_prefixes		= [var.loadbalancer_subnet_space]
}

resource azurerm_subnet aks {
	name = "aks-subnet"
	resource_group_name 	= azurerm_resource_group.pega.name
	virtual_network_name 	= azurerm_virtual_network.pega.name
	address_prefixes		= [var.aks_subnet_space]
}

resource azurerm_subnet jumpbox {
	name = "jumpbox-subnet"
	resource_group_name 	= azurerm_resource_group.pega.name
	virtual_network_name 	= azurerm_virtual_network.pega.name
	address_prefixes		= [var.jumpbox_subnet_space]
}