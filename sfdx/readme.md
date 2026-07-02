# sfdx

Salesforce Developer Experience - customized dev container image.

Can be run as user 1000 or 1001.

This docker image is based on debian.

## Manually

``` bash
docker run -it \
  --name sfdx-c1 \
  --network main \
  --user 1000 \
  ghcr.io/valorad/sfdx:latest
```

## Example VSCode devcontainer.json

Please check [example.devcontainer.json](./example.devcontainer.json).


