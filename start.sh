#!/bin/bash

#
# This file should be used to prepare and run your WebProxy after set up your .env file
# Source: https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion
#

# 1. Check if .env file exists
if [ -e .env ]; then
    source .env
else 
    echo "Please set up your .env file before starting your enviornment."
    exit 1
fi

# 2. Create docker network
docker network create $NETWORK

# 3. Verify if second network is configured
if [ ! -z ${SERVICE_NETWORK+X} ]; then
    docker network create $SERVICE_NETWORK
fi

# 4. Download the latest version of nginx.tmpl
curl https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl > nginx.tmpl

# 5. Update local images
docker-compose pull

# 6. Add any special configuration if it's set in .env file

# Check if user set to use Special Conf Files
if [ ! -z ${USE_NGINX_CONF_FILES+X} ] && [ "$USE_NGINX_CONF_FILES" = true ]; then

    # Create the conf folder if it does not exists
    mkdir -p $NGINX_FILES_PATH/conf.d

    # Copy the special configurations to the nginx conf folder
    cp -R ./conf.d/* $NGINX_FILES_PATH/conf.d

    # Check if there was an error and try with sudo
    if [ $? -ne 0 ]; then
        sudo cp -R ./conf.d/* $NGINX_FILES_PATH/conf.d
    fi

    # If there was any errors inform the user
    if [ $? -ne 0 ]; then
        echo
        echo "#######################################################"
        echo
        echo "There was an error trying to copy the nginx conf files."
        echo "The webproxy will still work, your custom configuration"
        echo "will not be loaded."
        echo 
        echo "#######################################################"
    fi
fi 

# 7. Start proxy

# Check if must use separated container
if [ ! -z ${USE_SEPARATED_CONATINER_SOCK+X} ] && [ "$USE_SEPARATED_CONATINER_SOCK" = true ]; then

    # Check if you have multiple network
    if [ -z ${SERVICE_NETWORK+X} ]; then
        COMPOSE_OPTIONS="-f docker-compose-separated-container.yml"
    else
        COMPOSE_OPTIONS="-f docker-compose-separated-container-multiple-networks.yml"
    fi
else

    # Check if you have multiple network
    if [ ! -z ${SERVICE_NETWORK+X} ]; then
        COMPOSE_OPTIONS="-f docker-compose-multiple-networks.yml"
    else
        COMPOSE_OPTIONS="-f docker-compose.yml"
    fi
fi

# Start proxy with Options
docker-compose $COMPOSE_OPTIONS up -d

echo $COMPOSE_OPTIONS

unset $COMPOSE_OPTIONS

exit 0
