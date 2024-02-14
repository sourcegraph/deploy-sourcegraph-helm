# Envoy Filter

This override file creates a new resource called `EnvoyFilter` to enable HTTP trailers on envoy for gitserver.

It is an example override file to apply a new envoy filter to resolve the following error message in gitserver caused by service mesh (ex. istio):

```
"git command [git rev-parse HEAD] failed (stderr: \"\"): strconv.Atoi: parsing \"\"
```
Hello World
