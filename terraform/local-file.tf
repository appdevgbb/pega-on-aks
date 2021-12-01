resource "local_file" "cluster-issuer" {
  content = templatefile("${path.module}/templates/cert-manager/cluster-issuer.tmpl", {
      cluster_admin_email = var.CLUSTER_ADMIN_EMAIL
  })
  filename = "${path.module}/temp/cert-manager/cluster-issuer.yaml"
  file_permission = "0640"
}

# resource "local_file" "ingress-nginx" {
#   content = templatefile("${path.module}/templates/ingress-nginx/values.tmpl", {
#     public_ip = azurerm_public_ip.pega.ip_address
#     resource_group_name = azurerm_resource_group.pega.name
#     dns_label_name = local.prefix
#   })
#   filename = "${path.module}/temp/ingress-nginx/values.yaml"
#   file_permission = "0640"
# }

resource "local_file" "ingress-traefik" {
  content = templatefile("${path.module}/templates/ingress-traefik/values.yaml", {
    public_ip = azurerm_public_ip.pega.ip_address
    resource_group_name = azurerm_resource_group.pega.name
    dns_label_name = local.prefix
  })
  filename = "${path.module}/temp/ingress-traefik/values.yaml"
  file_permission = "0640"
}

# resource "local_file" "pega-ingress" {
#   content = templatefile("${path.module}/templates/pega/ingress.yaml", {
#     domain_name = azurerm_public_ip.fqdn
#   })
#   filename = "${path.module}/temp/pega/ingress.yaml"
#   file_permission = "0640"
# }

resource "local_file" "pega" {
  content = templatefile("${path.module}/templates/pega/pega.yaml", {
    sql_connection_string = var.pega_database_connection_string
    acr_url = azurerm_container_registry.pega.login_server
    acr_username = azurerm_container_registry.pega.admin_username
    acr_password = azurerm_container_registry.pega.admin_password
    pega_version = var.pega_version
    pega_image = "${azurerm_container_registry.pega.login_server}/pega/pega:${var.pega_version}"
    domain_name = azurerm_public_ip.pega.fqdn
  })
  filename = "${path.module}/temp/pega/pega.yaml"
  file_permission = "0640"
}