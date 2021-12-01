variable "CLUSTER_ADMIN_EMAIL" {
	type = string
	default = ""
}

variable prefix {
	type = string
	default = "pega"
}

variable location {
	type = string
	default = "canadacentral"
}

variable environment {
	type = string
	default = "test"
}

variable vnet_address_space {
	type = string
	default = "10.1.0.0/16"
}

variable azure_firewall_subnet_space {
	type = string
	default = "10.1.0.0/26"
}

variable loadbalancer_subnet_space {
	type = string
	default = "10.1.0.64/26"
}

variable aks_subnet_space {
	type = string
	default = "10.1.4.0/22"
}

variable jumpbox_subnet_space {
	type = string
	default = "10.1.255.192/26"
}

variable "admin_username" {
  type = string
  default = "retroadmin"
}

variable aks_settings {
	type = object({
		kubernetes_version		= string
		private_cluster_enabled = bool
		identity 				= string
		outbound_type			= string
		network_plugin			= string
		network_policy			= string
		load_balancer_sku		= string
		service_cidr			= string
		dns_service_ip 			= string
		docker_bridge_cidr 		= string
	})
	default = {
		kubernetes_version		= null
		private_cluster_enabled = false
		identity 				= "SystemAssigned"
		outbound_type			= "loadBalancer"
		network_plugin			= "azure"
		network_policy			= "calico"
		load_balancer_sku		= "standard"
		service_cidr			= "192.168.0.0/24"
		dns_service_ip 			= "192.168.0.10"
		docker_bridge_cidr 		= "172.17.0.1/16"
	}
}

variable default_node_pool {
	type = object({
		name = string
		enable_auto_scaling = bool
		node_count = number
		min_count = number
		max_count = number
		vm_size = string
		type    = string
		os_disk_size_gb = number
	})
	
	default = {
		name = "defaultnp"
		enable_auto_scaling = true
		node_count = 2
		min_count = 2
		max_count = 5
		vm_size = "Standard_D4s_v3"
		type    = "VirtualMachineScaleSets"
		os_disk_size_gb = 30
	}
}

variable user_node_pools {
	type = map(object({
		vm_size = string
		node_count = number
		node_labels = map(string)
		node_taints = list(string)
	}))
	
	default = {
		"usernp1" = {
			vm_size = "Standard_D4s_v3"
			node_count = 3
			node_labels = null
			node_taints = []
		}
	}
}

variable pega_version {
	type = string
	default = "8.5.1"
}

variable pega_database_connection_string {
  type = string
}
