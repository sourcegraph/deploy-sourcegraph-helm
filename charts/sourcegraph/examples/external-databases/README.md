# Using external Postgres instances

Sourcegraph deployment by default ships three separate Postgres instances:

- [codeinsights-db.StatefulSet.yaml](../../templates/codeinsights-db/codeinsights-db.StatefulSet.yaml)
- [codeintel-db.StatefulSet.yaml](../../templates/codeintel-db/codeinsights-db.StatefulSet.yaml)
- [pgsql.StatefulSet.yaml](../../templates/pgsql/codeinsights-db.StatefulSet.yaml)

All three can be disabled individually and replaced with external Postgres instances.

For guidance on setup for the external instances, refer to the [Helm docs on using an external database](https://docs.sourcegraph.com/admin/install/kubernetes/helm#using-external-postgresql-databases).

The example [override.yaml] demonstrates various options for configuring access to the external databases.

## Providing credentials via Secret

You can provide database credentials in a [Secret](https://kubernetes.io/docs/concepts/configuration/secret/) managed outside the helm chart in a secure manner.

Each database requires its own Secret and should follow the following format. The names can be customized as desired:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: pgsql-credentials
data:
  # notes: secrets data has to be base64-encoded
  database: ""
  host: ""
  password: ""
  port: ""
  user: ""
```

The Secret name should be set in your override file in the `auth.existingSecret` key for each database. See the [override.yaml] for an example.

[override.yaml]: ./override.yaml
