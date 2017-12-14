#!/bin/bash

#CONTAINER=httpd:alpine
#CONTAINER=huggla/alpine-lighttpd2-fastcgi
CONTAINER=nfqlt/apache24-fastcgi

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
    #docker run -d -e VIRTUAL_HOST=$DOMAIN --network=$SERVICE_NETWORK --name test-web $CONTAINER
    docker run -d -e VIRTUAL_HOST=$DOMAIN -e VIRTUAL_ROOT=/home/project/src/www/web --network=$NETWORK --name test-web $CONTAINER
    #docker run -d -P --network=$NETWORK --name test-web $CONTAINER
    echo 'ups!'
fi

exit 0
