#!/bin/bash

export $(cat .env | xargs)

# Creates your role in postgres db
docker-compose run web psql postgres://postgres@db -c "CREATE ROLE myapp WITH LOGIN ENCRYPTED PASSWORD '$PASSWORD';"

# Creates databases for all environments used by rails
docker-compose run web psql postgres://postgres@db -c "create database myapp_production;"
docker-compose run web psql postgres://postgres@db -c "create database myapp_development;"
docker-compose run web psql postgres://postgres@db -c "create database myapp_test;"

# Nginx config
docker cp default.conf gds_webserver_1:/etc/nginx/conf.d/default.conf
docker exec -it gds_webserver_1 /etc/init.d/nginx reload

