# dotnet-sdk

Customized dev container image for dotnet (SDK)

Can be run as user 1000 or 1001.

This docker image is based on debian.

## Manually

``` bash
docker run -it \
  --name dotnet-sdk-c1 \
  --network main \
  --user 1000 \
  ghcr.io/valorad/dotnet-sdk:latest
```

## Example VSCode devcontainer.json

Please check [example.devcontainer.json](./example.devcontainer.json).

## Build a new image

Remember to configure the ARG sections in dockerfile.
(e.g. specify a version)
