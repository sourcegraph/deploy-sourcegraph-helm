# Sourcegraph Helm Chart

## Requirements

* [Helm 3 CLI](https://helm.sh/docs/intro/install/)
* Kubernetes 1.19 or greater

## Installation

* Add the Sourcegraph charts repo:
`helm repo add sourcegraph https://sourcegraph.github.io/deploy-sourcegraph-helm/`

* Install the chart using default values:
  `helm install sg sourcegraph/sourcegraph`

## Usage

To customize configuration settings, create an empty yaml file and configure
overrides according to the chart below. The install command would then be:

`helm install -f override.yaml sourcegraph/sourcegraph`

## Configuration Options

Reference the values.yaml file for available configuration parameters.

## Third-party resources

### cAdvisor

[cAdvisor](https://github.com/google/cadvisor) provides container users an understanding of the resource usage and performance characteristics of their running containers. It is a running daemon that collects, aggregates, processes, and exports information about running containers.

cAdvisor is part of the default Sourcegraph cluster installation, and deployed as a [Kubernetes DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/). This setup is based on the [official cAdvisor Kubernetes Daemonset configuration](https://github.com/google/cadvisor/tree/master/deploy/kubernetes). We use our own cAdvisor deployment over the built-in metrics exported by Kubernetes because the latter is often outdated and needs to be kept in sync with our [Docker-Compose deployments](https://docs.sourcegraph.com/admin/install/docker-compose). This setup allows us to have standard dashboards across all Sourcegraph deployments.

Note that the `sourcegraph/cadvisor` Docker images come with a set of default flags to help reduce memory usage and load on Prometheus - see [our Dockerfile](https://github.com/sourcegraph/sourcegraph/blob/master/docker-images/cadvisor/Dockerfile) for more details.

The cAdvisor deployment can be disabled by setting `cadvisor.enabled` to `false`, if you already run cadvisor on your cluster.

### Grafana

[Grafana](https://https://grafana.com/) is an open-source analytics dashboard application.

A Grafana instance is part of the default Sourcegraph cluster installation.
Learn more about Grafana in the [metrics and dashboards guide](https://docs.sourcegraph.com/admin/observability/metrics).

The Grafana deployment can be disabled by setting `grafana.enabled` to `false`. This is not recommended, as it severely limits your ability to monitor the health of your instance and troubleshoot any issues.

### Prometheus

[Prometheus](https://prometheus.io/) is an open-source application monitoring system and time series database.
 It is commonly used to track key performance metrics over time, such as the following:

- QPS
- Application requests by URL route name
- HTTP response latency
- HTTP error codes
- Time since last search index update

A Prometheus instance is part of the default Sourcegraph cluster installation.

The Prometheus deployment can be disabled by setting `prometheus.enabled` to `false`. This is not recommended, as it severely limits your ability to monitor the health of your instance and troubleshoot any issues. Instead, consider setting `prometheus.privileged` to `false`, which reduces the privileges required to deploy a Prometheus instance.
