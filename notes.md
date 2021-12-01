These values need to be updated on the values.yaml file of the Pega Helm chart:

1. SQL information

	|Parameter | Value
	|-|-
	| server | ${PEGA_DB_SERVER}.database.windows.net 
	| DB     | ${PEGA_DB}
	| username | ${SQL_USERNAME}
	| password | ${SQL_PASSWORD}

1. Pega credentials
	|Parameter | Value
	|-|-
	| akspocPegadmin| akspocp@ssw0rdp@ssw0rd
	| akspocPegauser|  akspocp@ssw0rdp@ssw0rd
	| akspocdeploy  |  akspocp@ssw0rdp@ssw0rd

1. Azure Container Registry information

	1. update search image repo line: ```${AZURE_CONTAINER_REGISTRY_NAME}.azurecr.io/pega/pega:8.5.1```

	1. provide the ```${AZURE_CONTAINER_REGISTRY_USERNAME}``` and ```${AZURE_CONTAINER_REGISTRY_PASSWORD}```

1. Pega Web UI Login

	|Parameter | Value
	|-|-
	| pega-app-id | administrator@pega.com
	| pega-app-pw | ${PEGA_UI_PASSWORD}

1. Ingress Controller

	1. provide the domain name ```${INGRESS_DOMAIN_NAME}``` this is the FQDN associate with the public ip address of the ingress controller.

1. HDInsight Cluster (when using Kafka outside of the cluster)
	|Parameter | Value
	|-|-
	| cluster login username | admin
	| cluster login password | Akpocp@ssw0rdP@ssw0rd

1. SSH 
	|Parameter | Value
	|-|-
	| username | sshuser
