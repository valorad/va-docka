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

### Error Failed to sync folder: Invalid argument

> mega-sync /local/folder /mega/cloud/folder
> 
> [API:err: 88:88:88] Failed to sync folder: Invalid argument

According to https://github.com/termux/termux-packages/issues/14097

A work-around is to provide a valid machine ID for the container to use.

- Prepare a machine ID with `dbus-uuidgen` or `systemd-machine-id-setup` in another OS.
  - you can also grab the existing one from your host machine by reading `/etc/machine-id`
- Exec into the container as the ROOT user
- create a new text file at `/etc/machine-id` and fill in your machine ID.
- retry the sync

