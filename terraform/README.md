# Pega Systems on Azure Kubernetes Services

## Architecture 

This demo of Pega runs on Azure with the architecture depicted below. For more information on how to deploy Pega and it's architecture please reffer to the following document: [Understanding the Pega Deployment Architecture](https://community.pega.com/knowledgebase/articles/client-managed-cloud/83/understanding-pega-deployment-architecture)



## Main components

| Name | Version |
|------|---------|
| Traefik |    |
| CerManager | 1.2.0 |
| Pega | 8.5.1 |
| Kubernetes | 1.19.0 |

## Infrastructure as Code with Terraform
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.49.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.49.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

### Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.pega](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/container_registry) | resource |
| [azurerm_kubernetes_cluster.pega](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.user](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_linux_virtual_machine.jumpbox001](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_log_analytics_workspace.aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_network_interface.jumpbox001](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/network_interface) | resource |
| [azurerm_public_ip.pega](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.pega](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.aks-acr](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks-loadbalancer](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/role_assignment) | resource |
| [azurerm_subnet.aks](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/subnet) | resource |
| [azurerm_subnet.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/subnet) | resource |
| [azurerm_subnet.jumpbox](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/subnet) | resource |
| [azurerm_subnet.loadbalancer](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/subnet) | resource |
| [azurerm_virtual_network.pega](https://registry.terraform.io/providers/hashicorp/azurerm/2.49.0/docs/resources/virtual_network) | resource |
| [local_file.cluster-issuer](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.ingress-traefik](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.pega](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.ssh-private-key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_password.master_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.example](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_CLUSTER_ADMIN_EMAIL"></a> [CLUSTER\_ADMIN\_EMAIL](#input\_CLUSTER\_ADMIN\_EMAIL) | n/a | `string` | `""` | no |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | n/a | `string` | `"retroadmin"` | no |
| <a name="input_aks_settings"></a> [aks\_settings](#input\_aks\_settings) | n/a | <pre>object({<br>		kubernetes_version		= string<br>		private_cluster_enabled = bool<br>		identity 				= string<br>		outbound_type			= string<br>		network_plugin			= string<br>		network_policy			= string<br>		load_balancer_sku		= string<br>		service_cidr			= string<br>		dns_service_ip 			= string<br>		docker_bridge_cidr 		= string<br>	})</pre> | <pre>{<br>  "dns_service_ip": "192.168.0.10",<br>  "docker_bridge_cidr": "172.17.0.1/16",<br>  "identity": "SystemAssigned",<br>  "kubernetes_version": null,<br>  "load_balancer_sku": "standard",<br>  "network_plugin": "azure",<br>  "network_policy": "calico",<br>  "outbound_type": "loadBalancer",<br>  "private_cluster_enabled": false,<br>  "service_cidr": "192.168.0.0/24"<br>}</pre> | no |
| <a name="input_aks_subnet_space"></a> [aks\_subnet\_space](#input\_aks\_subnet\_space) | n/a | `string` | `"10.1.4.0/22"` | no |
| <a name="input_azure_firewall_subnet_space"></a> [azure\_firewall\_subnet\_space](#input\_azure\_firewall\_subnet\_space) | n/a | `string` | `"10.1.0.0/26"` | no |
| <a name="input_default_node_pool"></a> [default\_node\_pool](#input\_default\_node\_pool) | n/a | <pre>object({<br>		name = string<br>		enable_auto_scaling = bool<br>		node_count = number<br>		min_count = number<br>		max_count = number<br>		vm_size = string<br>		type    = string<br>		os_disk_size_gb = number<br>	})</pre> | <pre>{<br>  "enable_auto_scaling": true,<br>  "max_count": 5,<br>  "min_count": 2,<br>  "name": "defaultnp",<br>  "node_count": 2,<br>  "os_disk_size_gb": 30,<br>  "type": "VirtualMachineScaleSets",<br>  "vm_size": "Standard_D4s_v3"<br>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"test"` | no |
| <a name="input_jumpbox_subnet_space"></a> [jumpbox\_subnet\_space](#input\_jumpbox\_subnet\_space) | n/a | `string` | `"10.1.255.192/26"` | no |
| <a name="input_loadbalancer_subnet_space"></a> [loadbalancer\_subnet\_space](#input\_loadbalancer\_subnet\_space) | n/a | `string` | `"10.1.0.64/26"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"canadacentral"` | no |
| <a name="input_pega_database_connection_string"></a> [pega\_database\_connection\_string](#input\_pega\_database\_connection\_string) | n/a | `string` | n/a | yes |
| <a name="input_pega_version"></a> [pega\_version](#input\_pega\_version) | n/a | `string` | `"8.5.1"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"pega"` | no |
| <a name="input_user_node_pools"></a> [user\_node\_pools](#input\_user\_node\_pools) | n/a | <pre>map(object({<br>		vm_size = string<br>		node_count = number<br>		node_labels = map(string)<br>		node_taints = list(string)<br>	}))</pre> | <pre>{<br>  "usernp1": {<br>    "node_count": 3,<br>    "node_labels": null,<br>    "node_taints": [],<br>    "vm_size": "Standard_D4s_v3"<br>  }<br>}</pre> | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | n/a | `string` | `"10.1.0.0/16"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_domain_name"></a> [cluster\_domain\_name](#output\_cluster\_domain\_name) | n/a |
| <a name="output_cluster_identity"></a> [cluster\_identity](#output\_cluster\_identity) | n/a |
| <a name="output_master_password"></a> [master\_password](#output\_master\_password) | n/a |
| <a name="output_username"></a> [username](#output\_username) | n/a |
