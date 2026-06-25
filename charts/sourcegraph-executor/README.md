# Sourcegraph executor helm charts

This directory contains two Helm charts for deploying executors on Kubernetes. [See the docs](https://sourcegraph.com/docs/self-hosted/executors/deploy-executors-kubernetes) for more information on executors on Kubernetes.

## Native Kubernetes (k8s)
This chart deploys executors that interact with the Kubernetes API to handle jobs.

> ⚠️ **Beta:** Native Kubernetes executors are in beta. For production workloads, consider deploying using
> [Terraform](https://sourcegraph.com/docs/self-hosted/executors/deploy-executors-terraform) or the
> [Linux binary](https://sourcegraph.com/docs/self-hosted/executors/deploy-executors-binary) for better long-term support.

Your cluster will need to allow configuration of the following RBAC rules:

| API Groups | Resources          | Verbs                     | Reason                                                                                    |
|------------|--------------------|---------------------------|-------------------------------------------------------------------------------------------|
| `batch`    | `jobs`             | `create`, `delete`        | Executors create Job pods to run processes. Once Jobs are completed, they are cleaned up. |
|            | `pods`, `pods/log` | `get`, `list`, `watch`    | Executors need to look up and steam logs from the Job Pods.                               |

## Docker in Docker (dind)

> ⚠️ **Beta:** Docker-in-Docker Kubernetes executors are not recommended for production use.
> This method requires privileged access to a container runtime daemon and does not use Firecracker
> isolation. For production workloads, consider a
> [non-Kubernetes method](https://sourcegraph.com/docs/admin/executors).

This chart deploys executors that deploy a [Docker in Docker](https://www.docker.com/blog/docker-can-now-run-within-docker/) sidecar with each executor pod to avoid accessing the host container runtime directly. This method requires privileged access to a container runtime daemon in order to operate correctly.
