#!/bin/bash

# https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus

NAMESPACE="${1:-openshift-monitoring}"

set -eu

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

check_installed(){
	if ! type "$1" &> /dev/null; then
		echo "Please install $1 to continue: $2"
		exit 1
	fi
}

SCRIPTS_DIR="$(dirname $(readlink -f "$0"))"

PROMETHEUS_OPERATOR_DIR="${SCRIPTS_DIR}/prometheus-operator"
CUSTOM_RULES_DIR="${SCRIPTS_DIR}/rules"
KUBE_PROMETHEUS_OPERATOR_DIR="${PROMETHEUS_OPERATOR_DIR}/contrib/kube-prometheus"
MANIFESTS_DIR="${KUBE_PROMETHEUS_OPERATOR_DIR}/manifests"

JSONNET_CONF="${KUBE_PROMETHEUS_OPERATOR_DIR}/${NAMESPACE}.conf.jsonnet"
PROMETHEUS_RULES="${MANIFESTS_DIR}/prometheus-rules.yaml"

check_installed oc "https://github.com/openshift/origin"
check_installed jb "https://github.com/jsonnet-bundler/jsonnet-bundler#install"
check_installed gojsontoyaml "https://github.com/brancz/gojsontoyaml#install"

pushd "${SCRIPTS_DIR}"
if [ ! -d "${PROMETHEUS_OPERATOR_DIR}" ]; then
	git clone https://github.com/coreos/prometheus-operator.git
fi
popd


pushd "${KUBE_PROMETHEUS_OPERATOR_DIR}"
jb install github.com/brancz/kubernetes-grafana/grafana
jb install

cp "${SCRIPTS_DIR}/conf.jsonnet" "${JSONNET_CONF}"
sed "s/\(namespace: '\)NAMESPACE/\1${NAMESPACE}/" -i "${JSONNET_CONF}"
./build.sh "${JSONNET_CONF}"
popd

for RULE in "${CUSTOM_RULES_DIR}"/*; do
    cat "${RULE}" >> "${PROMETHEUS_RULES}"
done

pushd "${MANIFESTS_DIR}"
for MANIFEST in *; do
	case "${MANIFEST}" in
        0prometheus-operator-deployment.yaml|\
        grafana-deployment.yaml|\
        kube-state-metrics-deployment.yaml|\
        node-exporter-daemonset.yaml)
		sed "s/\(runAsNonRoot: \)true/\1false/;/runAsUser/d" -i "${MANIFEST}"
        ;;
        alertmanager-alertmanager.yaml|\
        prometheus-prometheus.yaml)
		sed "/spec/a \  securityContext:\n    runAsNonRoot: false" -i "${MANIFEST}"
        ;;
        prometheus-service.yaml)
		sed 's/\(port: \)9090/\19091/' -i "${MANIFEST}"
        ;;
    esac
done
popd
