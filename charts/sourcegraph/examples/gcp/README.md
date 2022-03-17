# GCP

Deploy Sourcegraph on GKE and use [Container-native load balancing through Ingress] to make Sourcegraph publically accessible.

## Get started

Deploy or upgrade Sourcegraph Helm chart with the provided [override.yaml](./override.yaml)

> Looking to enable TLS with Google-managed certificates? [Learn more](https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs)

Deploy the [BackendConfig] CRD. This is necessary to instruct GCP load balancer how to perform healthcheck on our deployment.

```sh
kubectl apply -f sourcegraph-frontend.BackendConfig.yaml
```

[Container-native load balancing through Ingress]: https://cloud.google.com/kubernetes-engine/docs/how-to/container-native-load-balancing
[BackendConfig]: https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features#create_backendconfig
