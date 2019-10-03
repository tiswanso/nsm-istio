#!/bin/bash

# This script installs nsm_svc_reg to a k8s cluster.
#

sdir=$(dirname ${0})
#echo "$sdir"

HELMDIR=${HELMDIR:-${sdir}/../helm}
#echo "$HELMDIR"

usage() {
  echo "usage: $0 [OPTIONS]"
  echo ""
  echo "  MANDATORY OPTIONS:"
  echo ""
  echo "  --svcregkubeconfig=<kubeconfig>       set the kubeconfig for the cluster to use for the svcReg"
  echo "  --remotekubeconfig=<kubeconfig> set the kubeconfig for the cluster to watch for NSM clients"
  echo ""
  echo "  Optional OPTIONS:"
  echo ""
  echo "  --kubeconfig=<kubeconfig>  kubeconfig to install into"
  echo "  --namespace=<namespace>    set the namespace to watch for NSM clients"
  echo "  --delete                   delete the installation"
  echo ""
}


for i in "$@"; do
    case $i in
        -h|--help)
            usage
            exit
            ;;
        --kubeconfig=?*)
            KUBECONFIG=${i#*=}
            ;;
        --svcregkubeconfig=?*)
            SVCREGKUBECONFIG=${i#*=}
            ;;
        --remotekubeconfig=?*)
            REMOTEKUBECONFIG=${i#*=}
            ;;
        --namespace=?*)
            NAMESPACE=${i#*=}
            ;;
        --delete)
            DELETE=true
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

if [[ -z ${SVCREGKUBECONFIG} || -z ${REMOTEKUBECONFIG} ]]; then
    echo "ERROR: One of kubeconfig or remotekubeconfig not set."
    usage
    exit 1
fi

if [[ "${DELETE}" == "true" ]]; then
    helm template ${HELMDIR}/nsm_svc_reg ${NAMESPACE:+--set watchNamespace=$NAMESPACE} | kubectl delete -f -
    kubectl delete secret svcregkubeconfig
    kubectl delete secret watchkubeconfig
    exit 0
fi

kubectl create secret generic svcregkubeconfig --from-file=kubeconfig=${SVCREGKUBECONFIG}
kubectl create secret generic watchkubeconfig --from-file=kubeconfig=${REMOTEKUBECONFIG}

helm template ${HELMDIR}/nsm_svc_reg ${NAMESPACE:+--set watchNamespace=$NAMESPACE} | kubectl apply -f -
