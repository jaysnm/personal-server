#!/bin/bash

## Check that you have the most up to date repo
git pull
## Get secrets from google cloud containers
sudo bash get_from_bucket.sh
## Create a docker network to link containers
docker network create server-net
## Pull all required images - errors are from containers that need to be built
docker-compose -f containers/docker-compose.yml pull --ignore-pull-failures
## Build all custom images
docker-compose -f containers/docker-compose.yml build
## Change permissions for jenkins folder
sudo chmod -R 0755 secrets/jenkins
## Launch required control containers
docker-compose up -d
