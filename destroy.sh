#!/bin/bash

NAMESPACE="${1:-openshift-monitoring}"

SCRIPTS_DIR="$(dirname $(readlink -f "$0"))"
PROMETHEUS_OPERATOR_DIR="${SCRIPTS_DIR}/prometheus-operator"

"${SCRIPTS_DIR}/undeploy.sh" "${NAMESPACE}"
rm -rf "${PROMETHEUS_OPERATOR_DIR}"
