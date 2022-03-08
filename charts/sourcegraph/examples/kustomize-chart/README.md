# kustomize chart

This example demonstrate the escape hatch whenever you encounter something that our helm charts do not support yet. [Kustomize] allows you to apply [strategic merge patch] and [json patch] on helm chart without maintaining a custom fork. This is our **recommended** approach to customize helm chart, and you should avoid forking unless absolutely necessary.

## Customize `frontend` service port

In this example, we will change the `http` port of `sourcegraph-frontend.Service.yaml` and update the corresponding backend service port number in `sourcegraph-frontend.Ingress.yaml`.

> Below command should be run within the current directory

```sh
helm upgrade --install --create-namespace -n sourcegraph sourcegraph sourcegraph/sourcegraph --post-renderer ./kustomize
```

[kustomize]: https://kustomize.io
[strategic merge patch]: https://github.com/kubernetes/community/blob/master/contributors/devel/sig-api-machinery/strategic-merge-patch.md
[json patch]: https://kubernetes.io/docs/tasks/manage-kubernetes-objects/update-api-object-kubectl-patch/#use-a-json-merge-patch-to-update-a-deployment
