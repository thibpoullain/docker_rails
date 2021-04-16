#!/bin/sh

set -e

# docker build -t vrizzt/unac_ruby_base -f Dockerfile_ruby_base .
docker build -t vrizzt/unac_ruby_base_builder -f Dockerfile_ruby_base_builder .
docker build -t vrizzt/unac_ruby_base_final -f Dockerfile_ruby_base_final .

echo $DOCKER_HUB_TOKEN | docker login -u $DOCKER_HUB_USER --password-stdin
# docker push vrizzt/unac_ruby_base:latest
docker push vrizzt/unac_ruby_base_builder:latest
docker push vrizzt/unac_ruby_base_final:latest