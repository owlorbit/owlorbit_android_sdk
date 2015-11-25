#!/bin/sh

#docker cp ./ c0f48d9eef6d:html
#docker run --link mysql:db -d -p 7070:80 --name owlorbit -d richarvey/nginx-php-fpm
#docker run --link mysql:db -d -p 8080:80 --name sift -d richarvey/nginx-php-fpm
#setup link...

#ln -s /usr/share/nginx/html /html
#docker exec -it sift bash 

docker cp ./ sift:html