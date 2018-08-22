#!/bin/bash

NAMESPACE="${1:-openshift-monitoring}"

SCRIPTS_DIR="$(dirname $(readlink -f "$0"))"
MANIFESTS_DIR="${SCRIPTS_DIR}/prometheus-operator/contrib/kube-prometheus/manifests"

oc adm policy remove-scc-from-user hostaccess  -z node-exporter -n "${NAMESPACE}"
oc delete -f "${MANIFESTS_DIR}"

# wait for namespace to get deleted
echo "deleting namespace ${NAMESPACE}"

while oc get namespace "${NAMESPACE}" &> /dev/null; do
	sleep 1
	echo -n .
done 

echo
echo undeployed
