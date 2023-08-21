# mega-cmd

MEGA CMD is a command line tool to work with your MEGA account and files. Learn more at https://mega.nz/cmd

This docker image is based on debian.

## Docker compose

Please create your own version of `docker-compose.yaml` by following the [example file](docker-compose.run.example.yaml)

## Manually

``` bash
docker run -d \
--name mega-cmd-c1 \
--network main \
--user 1000 \
-v /sync/folder/1:/sync/folder/1 \
-v /sync/folder/2:/sync/folder/2 \
ghcr.io/valorad/mega-cmd:latest
```

## Note

It runs the `mega-cmd-server` when started.

Therefore you need to `docker exec` into your container, and do `mega-login`, `mega-sync`, etc. inside.

Please run the container as the user with UID in range 1000 - 1010 inclusive.

Please do NOT run as root. Otherwise, the permissions of your sync folders will all get messed-up!

