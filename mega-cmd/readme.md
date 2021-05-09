# mega-cmd

MEGA CMD is a command line tool to work with your MEGA account and files. Learn more at https://mega.nz/cmd

This docker image is based on debian.

It runs the `mega-cmd-server` when started.

Therefore you need to `docker exec` into your container, and do `mega-login`, `mega-sync`, etc. inside.

Please run the container as a root user.
