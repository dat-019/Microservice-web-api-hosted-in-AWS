#!/bin/bash
source deploy-envs.sh

export AWS_ECS_REPO_DOMAIN=$AWS_ACCOUNT_NUMBER.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com

export PATH=$PATH:$HOME/.local/bin # put aws in the path


# login to ecs for authentication
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin "$AWS_ECS_REPO_DOMAIN"/"$IMAGE_NAME1"

# image1
# one line to create a repos if it does not exist
aws ecr describe-repositories --repository-names "$IMAGE_NAME1" || aws ecr create-repository --repository-name "$IMAGE_NAME1"
# push created image into repos
docker push "$AWS_ECS_REPO_DOMAIN"/"$IMAGE_NAME1":"$IMAGE_VERSION"

# image2
aws ecr describe-repositories --repository-names "$IMAGE_NAME2" || aws ecr create-repository --repository-name "$IMAGE_NAME2"
docker push "$AWS_ECS_REPO_DOMAIN"/"$IMAGE_NAME2":"$IMAGE_VERSION"

$SHELL