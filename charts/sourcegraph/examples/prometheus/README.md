# Prometheus ConfigMap Override

## Why

- Some self-hosted customers run their instances on non-standard Kubernetes clusters, such as k3s, which expose metrics using different names / labels
- Our Grafana dashboards expect metrics to be on our Prometheus container with specific names
- Using the default configMap, the Grafana graphs do not show some metrics, although they may exist on Prometheus
- Use this configMap to rename k3s' metrics to match our Grafana dashboard queries

## How to Use

- Apply the override configMap via `kubectl apply -f prometheus-override-k3s.ConfigMap.yaml`
- Add the new configMap's name in your Helm values override file, ex:
```yaml
prometheus:
  existingConfig: prometheus-override-k3s
```
- Re-apply your Helm values override file, which may restart the Prometheus pod, but should not restart other services

## Notes

- Copied from https://github.com/sourcegraph/deploy/blob/main/install/prometheus-override.ConfigMap.yaml
- If this situation (matching symptoms and root cause) is found with other types of Kubernetes clusters, new Prometheus override configMaps could be created

## Troubleshooting Empty Grafana Dashboards

- There are a handful of steps in the metrics pipeline where data could be getting lost:
    - Are the cAdvisor, node-exporter, Prometheus, and Grafana containers all running, and healthy?
    - Are any of these pods reporting any issues in their Kubernetes events, or container logs?
    - Is network connectivity open from Prometheus to each of the cAdvisor / node-exporter containers?
    - Is network connectivity open from Grafana to Prometheus?
    - Does Prometheus have access to Kubernetes RBAC roles to use Service Discovery to find the IP addresses of cAdvisor and node-exporter pods?