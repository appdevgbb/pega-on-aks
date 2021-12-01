# Pega PoC

## Related Docs:
[Pega Instructions for AKS Deployment](https://github.com/pegasystems/pega-helm-charts/blob/master/docs/Deploying-Pega-on-AKS.md)
[Pega Helm Charts](https://github.com/pegasystems/pega-helm-charts)
[Pega Add-ons Chart](https://github.com/pegasystems/pega-helm-charts/tree/master/charts/addons#addons-helm-chart)

## AKS Cluster installation:

The ```run()``` function found in the [terraform/run.sh](terraform/run.sh) file will do the following:
- Create Required Azure Resources via Terraform (e.g. RG, VNET, Subnets, AKS, etc.) via the ```terraformDance()``` function
- Install [ingress-nginx](https://github.com/kubernetes/ingress-nginx#:~:text=ingress-nginx%20is%20an%20Ingress%20controller%20for%20Kubernetes%20using,about%20Ingress%20on%20the%20main%20Kubernetes%20documentation%20site.) via the ```installIngressNginx()``` function
    - **NOTE:** Terraform will generate the values file required to deploy with the proprely annotated values for the ingress-controller to deploy
        - See: [terraform/templates/ingress-nginx/values.tmpl](terraform/templates/ingress-nginx/values.tmpl) for annotation/config details 
- Install [cert-manager](https://cert-manager.io/docs/installation/) via the ```installCertManager()``` function
    - This function will also install a ```cluster-issuer``` that can request a public SSL certificate from letsencrypt for each ingress created for the cluster

```bash
cd terraform
source run.sh
run
```
