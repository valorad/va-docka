# nginx-php-mongo
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
-v /path/to/your/sitename.com:/workspace/www \
-v /path/to/nginx/conf.d:/etc/nginx/conf.d \
-v /path/to/docking:/workspace/docking \
valorad/nginx-php-mongo
```