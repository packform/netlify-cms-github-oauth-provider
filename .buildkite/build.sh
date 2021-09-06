#!/usr/bin/env bash

# This script runs the build process for the Dockerfile defined in this repo.

# Do the following prior to run:
# 1) Set these environment variables:
#    AWS_DEFAULT_REGION    - for now "us-west-1"
#    AWS_ACCESS_KEY_ID     - for now use value in Ansible production playbooks
#    AWS_SECRET_ACCESS_KEY - for now use value in Ansible production playbooks
# 2) Ensure current working directory set to root of this repo

registry=495388981531.dkr.ecr.us-west-1.amazonaws.com

set -e

echo "Logging in to the Docker image registry..."
aws ecr get-login-password | docker login --username AWS --password-stdin $registry

set +e

echo "Building and uploading image..."
sha="$(git rev-parse HEAD)"
docker build -f Dockerfile -t $registry/pp-web-oauth:$sha . --force-rm
[[ "$?" -ne "0" ]] && docker logout $registry && exit -1
docker push $registry/pp-web-oauth:$sha
[[ "$?" -ne "0" ]] && docker logout $registry && exit -1

docker logout $registry
