#!/bin/bash

docker cp default.conf gds_webserver_1:/etc/nginx/conf.d/default.conf
docker exec -it gds_webserver_1 /etc/init.d/nginx reload
