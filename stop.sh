#!/bin/bash

#
# This file should be used to stop your WebProxy after set up your .env file
# Source: https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion
#

# 1. Check if .env file exists
if [ -e .env ]; then
    source .env
else 
    echo "Please make sure you have set up your env file."
    exit 1
fi

# 2. Stop proxy

docker-compose down

# Check if it uses separated container
if [ ! -z ${USE_SEPARATED_CONATINER_SOCK+X} ] && [ "$USE_SEPARATED_CONATINER_SOCK" = true ]; then
    if [ ! -z ${DOCKER_GEN+X} ]; then
        docker stop $DOCKER_GEN
    else
        docker stop nginx-gen
    fi
fi

# 3. Delete Networks

if [ ! -z ${NETWORK+X} ]; then
    docker network rm $NETWORK
else
    docker network rm webproxy
fi

if [ ! -z ${SERVICE_NETWORK+X} ]; then
    docker network rm $SERVICE_NETWORK
else
    docker network rm webservices
fi

# 3. Clean up config files

# Rename folder to save old onfiguration
#sudo rm -rf $NGINX_FILES_PATH/old_2.conf.d
#sudo mv $NGINX_FILES_PATH/old.conf.d $NGINX_FILES_PATH/old_2.conf.d
#sudo mv $NGINX_FILES_PATH/conf.d $NGINX_FILES_PATH/old.conf.d


exit 0
