# Prometheus Operator on OpenShift

Can be used instead of [Cluster Monitoring Operator](https://github.com/openshift/cluster-monitoring-operator)<sup>1</sup> to deploy [Prometheus Operator](https://github.com/coreos/prometheus-operator) to [Openshift](https://github.com/openshift/origin)<sup>2</sup>. Uses preconfigured prometheus targets, rules, alerts and grafana dashboards

**[1]**: which is unstable ATM <br/>
**[2]**: tested with v3.10.0 <br/>

## Usage

- you can specify namespace for each script as a parameter (uses `openshift-monitoring` by default)
- openshift-monitoring namespace has to be used to be detected by [openshift/console](https://github.com/openshift/console)

#### Initialize YAML files

```
./init.sh
```


#### Deploy on OC cluster

```
./deploy.sh
```

- Prometheus is accessible at [prometheus-k8s-openshift-monitoring.127.0.0.1.nip.io](prometheus-k8s-openshift-monitoring.127.0.0.1.nip.io)
- Grafana is accessible at [grafana-openshift-monitoring.127.0.0.1.nip.io](grafana-openshift-monitoring.127.0.0.1.nip.io)
    - username: admin
    - password: admin
    - datasource in openshift-monitoring namespace should look like this : http://prometheus-k8s.openshift-monitoring.svc:9090
- Alert Manager is accessible at [alertmanager-main-openshift-monitoring.127.0.0.1.nip.io](alertmanager-main-openshift-monitoring.127.0.0.1.nip.io)



#### Remove deployment

```
./undeploy.sh
```

#### Clean up all intermediate files

```
./destroy.sh
```
