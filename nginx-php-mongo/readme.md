# nginx-php-mongo
[![Docker Pulls](https://img.shields.io/docker/pulls/valorad/nginx-php-mongo.svg?style=flat-square)](https://hub.docker.com/r/valorad/nginx-php-mongo/)

nginx-php-mongo based on php:fpm-alpine

## build
``` bash
# bash
docker build -t nginx-php-mongo .
```

## run
``` bash
# bash
docker run -d --name nginx-php-mongo-c \
-p 80:80 \
-p 443:443 \
-e EXEC_USER=$USER -e EXEC_USER_ID=$UID \
-v /path/to/your/sitename.com:/workspace/www/sitename.com \
-v /path/to/nginx/conf.d:/etc/nginx/conf.d \
-v /path/to/docking:/workspace/docking \
valorad/nginx-php-mongo
```

## exec into container as a non-root user
``` bash
$ docker exec -it nginx-php-mongo-c /workspace/shell.sh
# or when the container is stopped
# $ docker run --rm -it -e EXEC_USER=$USER -e EXEC_USER_ID=$UID --entrypoint /workspace/shell.sh valorad/nginx-php-mongo 
```