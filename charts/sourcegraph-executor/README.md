# Sourcegraph executor helm charts

This directory contains two Helm charts for deploying executors on Kubernetes. [Read the docs](https://docs.sourcegraph.com/admin/executors/deploy_executors_kubernetes) for more information on executors on Kubernetes.

## Native Kubernetes (k8s)
This chart deploys executors that interact with the Kubernetes API to handle jobs. This is the preferred deployment option.  
Your cluster will need to allow configuration of the following RBAC rules:

| API Groups | Resources          | Verbs                     | Reason                                                                                    |
|------------|--------------------|---------------------------|-------------------------------------------------------------------------------------------|
| `batch`    | `jobs`             | `create`, `delete`        | Executors create Job pods to run processes. Once Jobs are completed, they are cleaned up. |
|            | `pods`, `pods/log` | `get`, `list`, `watch`    | Executors need to look up and steam logs from the Job Pods.                               |

## Docker in Docker (dind)
This chart deploys executors that deploy a [Docker in Docker](https://www.docker.com/blog/docker-can-now-run-within-docker/) sidecar with each executor pod to avoid accessing the host container runtime directly. This method requires privileged access to a container runtime daemon in order to operate correctly.  
If you have security concerns, consider deploying via [a non-Kubernetes method](https://docs.sourcegraph.com/admin/executors).
