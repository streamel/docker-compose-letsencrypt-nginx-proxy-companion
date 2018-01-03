#!/bin/bash

#CONTAINER=httpd:alpine
#CONTAINER=php:fpm
CONTAINER=php:7.2-fpm

# Set up your DOMAIN
if [ $# -eq 0 ]; then
    echo "Please inform your domain name to test your proxy."
    echo "./start_test.sh $1"
    exit 1
else
    DOMAIN=$1
fi

# Read your .env file
source .env

# Testing your proxy
if [ -z ${SERVICE_NETWORK+X} ]; then
    docker run -d -e VIRTUAL_HOST=$DOMAIN --network=$NETWORK --name test-web $CONTAINER
else
    docker run -d -e VIRTUAL_HOST=$DOMAIN -e VIRTUAL_PROTO=fastcgi -e VIRTUAL_ROOT=/var/www/html --network=$NETWORK --name test-web $CONTAINER
    #docker run -d -P --network=$NETWORK --name test-web $CONTAINER
    echo 'ups!'
fi

exit 0
