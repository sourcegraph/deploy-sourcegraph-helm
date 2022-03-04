# Using external Redis instances

Sourcegraph deployment by default ships two separate Redis instances for different purposes

- [redis-cache.Deployment.yaml](../../templates/redis/redis-cache.Deployment.yaml)
- [redis-store.Deployment.yaml](../../templates/redis/redis-store.Deployment.yaml)

When using external Redis instances, you’ll need to specify the corresponding environment variable for each of the following deployments:

> __IMPORTANT__: This list may not be up-to-date. You should always consult the [offical docs](https://docs.sourcegraph.com/admin/install/kubernetes/configure#configure-custom-redis) for the latest list of dependent services.

- [sourcegraph-frontend.Deployment.yaml](../../templates/frontend/sourcegraph-frontend.Deployment.yaml)
- [repo-updater.Deployment.yaml](../../templates/repo-updater/repo-updater.Deployment.yaml)
- [gitserver.Deployment.yaml](../../templates/gitserver/gitserver.Deployment.yaml)
- [searcher.Deployment.yaml](../../templates/searcher/searcher.Deployment.yaml)
- [symbols.Deployment.yaml](../../templates/symbols/symbols.Deployment.yaml)
- [worker.Deployment.yaml](../../templates/worker/worker.Deployment.yaml)
## Option 1 - One shared external Redis instance

Example values override [override-shared.yaml](./override-shared.yaml)

### `REDIS_ENDPOINT`

The string must either have the format `$HOST:PORT` or follow the [IANA specification for Redis URLs](https://www.iana.org/assignments/uri-schemes/prov/redis) (e.g., redis://:mypassword@host:6379/2)

## Option 2 - Two separate external Redis instances

Example values override [override-separate.yaml](./override-separate.yaml)

### `REDIS_CACHE_ENDPOINT`

The string must either have the format `$HOST:PORT` or follow the [IANA specification for Redis URLs](https://www.iana.org/assignments/uri-schemes/prov/redis) (e.g., redis://:mypassword@host:6379/2)

### `REDIS_STORE_ENDPOINT`

The string must either have the format `$HOST:PORT` or follow the [IANA specification for Redis URLs](https://www.iana.org/assignments/uri-schemes/prov/redis) (e.g., redis://:mypassword@host:6379/2)

## Notes

You may store these sensitive environment variables in a [Secret](https://kubernetes.io/docs/concepts/configuration/secret/).

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: sourcegraph-external-redis-credentials
data:
  # notes: secrets data has to be base64-encoded
  REDIS_ENDPOINT: ""
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: sourcegraph-external-redis-credentials
data:
  # notes: secrets data has to be base64-encoded
  REDIS_CACHE_ENDPOINT: ""
  REDIS_STORE_ENDPOINT: ""
```

Optionally, if your external Redis instances do not required authentication, you may use a [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/). Learn more about [how to reference ConfigMap](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#define-container-environment-variables-using-configmap-data).

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: sourcegraph-external-redis-credentials
data:
  REDIS_ENDPOINT: "redis://redis.example.com:6379/2"
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: sourcegraph-external-redis-credentials
data:
  REDIS_CACHE_ENDPOINT: "redis://redis-cache.example.com:6379/2"
  REDIS_STORE_ENDPOINT: "redis://redis-store.example.com:6379/2"
```
