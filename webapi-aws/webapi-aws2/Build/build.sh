#!/bin/bash
source ../build-envs.sh

#AWS_ACCOUNT_NUMBER={} set in private variable
export AWS_ECS_REPO_DOMAIN=$AWS_ACCOUNT_NUMBER.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com

# Build process
docker build -t $IMAGE_NAME2 ../
docker tag $IMAGE_NAME2 $AWS_ECS_REPO_DOMAIN/$IMAGE_NAME2:$IMAGE_VERSION

$SHELL
