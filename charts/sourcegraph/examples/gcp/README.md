# GCP

Deploy Sourcegraph on GKE and use [Container-native load balancing through Ingress] to make Sourcegraph publicly accessible.

Additionally, it will configure output logs format that works better with GCP Logging by setting `SRC_LOG_FORMAT=json_gcp` in all services.

## Get started

Deploy or upgrade Sourcegraph Helm chart with the provided [override.yaml](./override.yaml). This will create a public-facing load balancer that supports HTTP traffic. You can then access your deployment via the IP of the load balancer.

**To enable HTTPS**, provide [your own SSL cert] or use [Google-managed certificates].

The override file includes a [BackendConfig] CRD. This is necessary to instruct GCP load balancer how to perform healthcheck on our deployment.

[Container-native load balancing through Ingress]: https://cloud.google.com/kubernetes-engine/docs/how-to/container-native-load-balancing
[BackendConfig]: https://cloud.google.com/kubernetes-engine/docs/how-to/ingress-features#create_backendconfig
[your own SSL cert]: https://cloud.google.com/kubernetes-engine/docs/concepts/ingress-xlb#setting_up_https_tls_between_client_and_load_balancer
[Google-managed certificates]: https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs
