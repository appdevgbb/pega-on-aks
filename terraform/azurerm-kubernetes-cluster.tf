resource azurerm_kubernetes_cluster pega {
  name                = "${local.prefix}-aks-cluster"
  location            = azurerm_resource_group.pega.location
  resource_group_name = azurerm_resource_group.pega.name
  
  dns_prefix          = "${local.prefix}-aks-cluster"
  
  kubernetes_version  = var.aks_settings.kubernetes_version
  private_cluster_enabled = var.aks_settings.private_cluster_enabled

  default_node_pool {
    name                = var.default_node_pool.name
    enable_auto_scaling = var.default_node_pool.enable_auto_scaling
    min_count           = var.default_node_pool.min_count
    max_count           = var.default_node_pool.max_count
    vm_size             = var.default_node_pool.vm_size
    os_disk_size_gb     = var.default_node_pool.os_disk_size_gb
    type                = var.default_node_pool.type
    vnet_subnet_id      = azurerm_subnet.aks.id
  }

  identity {
    type = var.aks_settings.identity
  }

  network_profile {
    network_plugin     = var.aks_settings.network_plugin
    network_policy     = var.aks_settings.network_policy
    load_balancer_sku  = var.aks_settings.load_balancer_sku
    service_cidr       = var.aks_settings.service_cidr
    dns_service_ip     = var.aks_settings.dns_service_ip
    docker_bridge_cidr = var.aks_settings.docker_bridge_cidr
    outbound_type      = var.aks_settings.private_cluster_enabled == true ? "userDefinedRouting" : "loadBalancer"
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
    }
    kube_dashboard {
      enabled = false
    }
  }
}

resource azurerm_kubernetes_cluster_node_pool user {
  for_each = var.user_node_pools

  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.pega.id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  mode                  = "User"
  node_labels           = each.value.node_labels
  vnet_subnet_id        = azurerm_subnet.aks.id
  node_taints           = each.value.node_taints
}

resource "azurerm_role_assignment" "aks-loadbalancer" {
  scope                = azurerm_resource_group.pega.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.pega.identity[0].principal_id
}

resource "azurerm_role_assignment" "aks-acr" {
  scope                = azurerm_resource_group.pega.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.pega.identity[0].principal_id
}