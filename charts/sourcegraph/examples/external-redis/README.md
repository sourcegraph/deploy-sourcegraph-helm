# Using external Redis instances

Sourcegraph deployment by default ships two separate Redis instances for different purposes

- [redis-cache.Deployment.yaml](../../templates/redis/redis-cache.Deployment.yaml)
- [redis-store.Deployment.yaml](../../templates/redis/redis-store.Deployment.yaml)

When using external Redis instances, you’ll need to specify the new endpoint for each. You can specify the endpoint directly in the values file, or by referencing an existing secret.

## Option 1 - Customize endpoint in override file (Endpoint does not require authentication)

Example values override [override.yaml](./override.yaml)

The `endpoint` setting must either have the format `$HOST:PORT` or follow the [IANA specification for Redis URLs](https://www.iana.org/assignments/uri-schemes/prov/redis) (e.g., redis://:mypassword@host:6379/2)

## Option 2 - Reference endpoint saved in an existing secret (Authentication required)

If your endpoint requires authentication, we recommend storing the credentials in a [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) created outside of the helm chart and managed in a secure manner.

Each Redis instance requires a separate Secret with the following format. The names can be customized as desired:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: redis-store-connection
data:
  # notes: secrets data has to be base64-encoded
  endpoint: ""
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: redis-cache-connection
data:
  # notes: secrets data has to be base64-encoded
  endpoint: ""
```

The Secret names should be configured in your override file in the `connection.existingSecret` key for each Redis. Example: [override-secret.yaml](./override-secret.yaml)

Hello World
