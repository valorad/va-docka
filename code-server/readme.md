# code-server images

[Code Server](https://github.com/cdr/code-server) images based on different dev environments. It aims to serve as a temporary solution for "[dev-containers](https://code.visualstudio.com/docs/remote/containers)" in the Code OSS environment.

## Currently available images online

See packages on the right side of this Github repository.

## Run

I recommend running with `docker-compose`. You may create a customized `docker-compose.yml` following this [example](./docker-compose.run.example.yaml). Then do:

``` bash
docker-compose up -d
```

Note that you can customize the config.yaml for code-server configuration.

The default code-server config is shown [here](./common/config.yaml). You will use that password to log in to the server.

The default **sudo** password is `please_change`. Some images might be different, so double-check the `EXEC_PASSWD` variable in the dockerfile.

But you can always create a new user by passing the specific env variables in docker-compose file.

Before you start running, double-check the config file + docker-compose file, make sure it is what you want.

Also, remember to create a docker network called `main` if you follow the provided example.

## Run Manually

Here is an example to run the container manually, if for any reason you are not using `docker-compose`:

``` bash
docker run -d \
--name code-server-node-c1 \
--network main \
-p 18848:8848 \
-v /workspace/www/code-server/config.yaml:/etc/codeServer/config.yaml \
-v /workspace/workbench:/workspace/workbench \
ghcr.io/valorad/code-server-node:latest
```

Change the image sufix, tag, container name, arguments, etc. according to your needs.

## Build

This group uses `docker-compose` to manage the build process. To start building, simply run:

``` bash
docker-compose build
```

## Build manually

If you choose to build manually via `docker` command, remember you need to set docker context exactly in this directory, along with `readme.md`.

Don't go inside the docker file directory and start building. It just will not work! (The COPY path will be all wrong).

For example, you should NOT do:

``` bash
cd ./node
docker build -t niubi-cs-node:latest . # ❌ WRONG! 
```

Instead, you should do:

``` bash
docker build -f ./node/dockerfile -t niubi-cs-node:latest # ✔️
```
