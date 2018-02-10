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
-v /path/to/your/sitename.com:/workspace/www/sitename.com \
-v /path/to/nginx/conf.d:/etc/nginx/conf.d \
-v /path/to/docking:/workspace/docking \
nginx-php-mongo
```