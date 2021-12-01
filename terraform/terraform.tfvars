location = "eastus"

aks_settings = {
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

default_node_pool = {
    name = "defaultnp"
    enable_auto_scaling = true
    node_count = 2
    min_count = 2
    max_count = 5
    vm_size = "Standard_D4s_v3"
    type    = "VirtualMachineScaleSets"
    os_disk_size_gb = 30
}

user_node_pools = {
    "usernp1" = {
        vm_size = "standard_d8s_v3"
        node_count = 3
        node_labels = null
        node_taints = []
    }
}

pega_database_connection_string = "jdbc:sqlserver://akspocdbsrv1.database.windows.net:1433;database=aksdb1;user=akssrvadmin@akspocdbsrv1;password={your_password_here};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
