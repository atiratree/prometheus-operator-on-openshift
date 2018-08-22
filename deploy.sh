#!/bin/bash

NAMESPACE="${1:-openshift-monitoring}"

set -eu

SCRIPTS_DIR="$(dirname $(readlink -f "$0"))"

PROMETHEUS_MANIFESTS_DIR="${SCRIPTS_DIR}/prometheus-operator/contrib/kube-prometheus/manifests"
MANIFESTS_DIR="${SCRIPTS_DIR}/manifests"

oc adm policy add-scc-to-user hostaccess  -z node-exporter -n "${NAMESPACE}"
oc create -f "${PROMETHEUS_MANIFESTS_DIR}"
oc create -f "${MANIFESTS_DIR}"
