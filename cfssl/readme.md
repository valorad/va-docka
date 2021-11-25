# cfssl

CFSSL is CloudFlare's PKI/TLS swiss army knife. It is both a command line tool and an HTTP API server for signing, verifying, and bundling TLS certificates.

Learn more at https://cfssl.org/ and https://github.com/cloudflare/cfssl

This docker image is extracted from [official docker image](https://github.com/cloudflare/cfssl/blob/master/Dockerfile.alpine), but runs the server instead of the cli at the entry point.

## Docker compose

Please create your own version of `docker-compose.yaml` by following the [example file](docker-compose.run.example.yaml)

## Manually

``` bash
docker run -d \
--name cfssl-c1 \
--network main \
--user 1000 \
ghcr.io/valorad/cfssl:latest
```

## Note


