terraform {
	# backend azurerm {
	# 	key	= "infra-hub.terraform.tfstate"
	# }
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "2.49.0"
		}
	}
}

provider azurerm {
	features {}
}

provider kubernetes {
	host                   = azurerm_kubernetes_cluster.pega.kube_config.0.host
	
	client_certificate     = base64decode(azurerm_kubernetes_cluster.pega.kube_config.0.client_certificate)
	client_key             = base64decode(azurerm_kubernetes_cluster.pega.kube_config.0.client_key)
	cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.pega.kube_config.0.cluster_ca_certificate)
}

provider helm {
	kubernetes {
		host                   = azurerm_kubernetes_cluster.pega.kube_config.0.host
		username               = azurerm_kubernetes_cluster.pega.kube_config.0.username
		password               = azurerm_kubernetes_cluster.pega.kube_config.0.password
		client_certificate     = base64decode(azurerm_kubernetes_cluster.pega.kube_config.0.client_certificate)
		client_key             = base64decode(azurerm_kubernetes_cluster.pega.kube_config.0.client_key)
		cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.pega.kube_config.0.cluster_ca_certificate)
	}
}

resource random_string suffix {
  length = 4
  special = false 
  upper = false
  lower = true
  number = false
}

resource "random_password" "master_password" {
  length = 16
  special = true
  min_lower = 1
  min_upper = 1
  min_numeric = 1
  min_special = 1
  override_special = "_%-="
}

locals {
	# prefix = "${azurerm_resource_group.pega.name}-${random_string.suffix.result}"
	prefix = "${var.prefix}-${var.location}-${random_string.suffix.result}"
	master_password   = random_password.master_password.result
	ingress-cluster-issuer = templatefile("${path.module}/templates/cert-manager/cluster-issuer.tmpl", {
    	cluster_admin_email = var.CLUSTER_ADMIN_EMAIL
  	})
}