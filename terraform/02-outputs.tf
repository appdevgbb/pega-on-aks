output username {
  value = var.admin_username
}

output master_password {
  value = local.master_password
}

output cluster_identity {
  value = azurerm_kubernetes_cluster.pega.identity[0].principal_id
}

output cluster_domain_name {
  value = azurerm_public_ip.pega.fqdn
}