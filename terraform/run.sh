#!/bin/bash

PEGA_VALUES_FILE=templates/pega/pega.yaml

__usage="
Available Commands:
  [-x  action]        action to be executed. 

  Possible verbs are:
    install         creates all of the resources in Azure and in Kubernetes
    destroy         terraform destroy all of the components but keeps the Terraform state files

  Pega specific actions:
    pega-reinstall  	deletes pega and reinstalls it. this will keep all of the PV/PVCs and SVCs
    pega-remove  	deletes pega but keep all of the PV/PVCs and SVCs
"

usage() {
  echo "usage: ${0##*/} [options]"
  echo "${__usage/[[:space:]]/}"
  exit 1
}

terraformDance() {
  # Deploy cluster
  terraform init
  terraform plan -out tfplan
  terraform apply -auto-approve tfplan
}

installIngressTraefik() {
  # Add Required Helm Repos
  helm repo add traefik https://helm.traefik.io/traefik
  #helm repo update

  #helm install ingress-traefik traefik/traefik \
  #  -n ingress-traefik \
  #  --values templates/ingress-traefik/values.yaml

  # Install ingress-traefik
  helm install ingress-traefik traefik/traefik \
    --namespace ingress-traefik \
    --create-namespace \
    --values temp/ingress-traefik/values.yaml

  sleep 10s
  kubectl apply -f templates/pega/ingress.yaml

}

deleteIngressTraefik() {
  helm uninstall --namespace ingress-traefik ingress-traefik
  kubectl delete -f templates/pega/ingress.yaml
}

installCertManager() {
  # Install cert-manager
  helm repo add jetstack https://charts.jetstack.io
  #helm repo update

  helm install cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --version v1.2.0 \
    --create-namespace \
    --set installCRDs=true

  # Install cluster-issuer
  sleep 30s
  kubectl apply -f temp/cert-manager/cluster-issuer.yaml -n cert-manager
}

installPega() {
  # Install Pega
  #helm repo add pega https://dl.bintray.com/pegasystems/pega-helm-charts
  #helm repo update

  kubectl create ns mypega 2>/dev/null
  kubectl create ns pegaaddons 2>/dev/null

  #helm install mypega pega/pega --namespace mypega --values ${PEGA_VALUES_FILE}

  helm install --namespace mypega --values templates/pega/pega-29-03-2021.yaml mypega templates/helm-chart/pega/
}

deletePega() {
  helm uninstall --namespace mypega mypega 2>/dev/null
  sleep 30
}

installKubecost() {
  kubectl create namespace kubecost
  helm repo add kubecost https://kubecost.github.io/cost-analyzer/
  helm install kubecost kubecost/cost-analyzer --namespace kubecost --set kubecostToken="ZGllZ28uY2FzYXRpQG1pY3Jvc29mdC5jb20=xm343yadf98"
}

showKubecost() {
  kubectl port-forward --namespace kubecost deployment/kubecost-cost-analyzer 9090
  echo "To see Kubecost please open http://localhost:9090/"
}

run() {
  # Create Cluster and install all associated services
  terraformDance
  installIngressTraefik
  installCertManager
}

exec_case() {
  local _opt=$1

  case ${_opt} in
  install) run ;;
  destroy) destroy ;;
  pega-reinstall)
    deleteIngressTraefik
    deletePega
    installPega
    installIngressTraefik
    ;;
  pega-remove)
    deletePega
    ;;
  ingress-reinstall)
    deleteIngressTraefik
    installIngressTraefik
    ;;
  kubecost-install)
    installKubecost
    ;;
  kubecost-show)
    showKubecost
    ;;
  *) usage ;;
  esac
  unset _opt
}

while getopts "f:x:" opt; do
  case $opt in
  f)
    PEGA_VALUES_FILE="${OPTARG}"
    ;;
  x)
    exec_flag=true
    EXEC_OPT="${OPTARG}"
    ;;
  *) usage ;;
  esac
done
shift $(($OPTIND - 1))

if [ $OPTIND = 1 ]; then
  usage
  exit 0
fi

if [[ "${exec_flag}" == "true" ]]; then
  exec_case "${EXEC_OPT}"
fi

exit 0
