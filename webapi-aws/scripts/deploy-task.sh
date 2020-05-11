#!/bin/bash
source deploy-envs.sh

export AWS_ECS_REPO_DOMAIN=$AWS_ACCOUNT_NUMBER.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
export ECS_TASK=tngo25-webapi-task

export PATH=$PATH:$HOME/.local/bin # put aws in the path

# replace environment variables in task-definition
envsubst < task-definition.json > new-task-definition.json

aws ecs register-task-definition --cli-input-json file://new-task-definition.json --region $AWS_DEFAULT_REGION > /dev/null # Create a new task revision


$SHELL