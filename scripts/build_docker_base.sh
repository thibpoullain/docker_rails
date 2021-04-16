#!/bin/sh

set -e

docker build -t vrizzt/unac_prod_base_builder -f Dockerfile_prod_base_builder .
docker build -t vrizzt/unac_prod_base_final -f Dockerfile_prod_base_final .

echo $DOCKER_HUB_TOKEN | docker login -u $DOCKER_HUB_USER --password-stdin
docker push vrizzt/unac_prod_base_builder:latest
docker push vrizzt/unac_prod_base_final:latest