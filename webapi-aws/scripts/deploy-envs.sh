#!/bin/bash

# set environment variables used in deploy.sh and AWS task-definition.json:
export IMAGE_NAME1=tngo25-webapi1-app
export IMAGE_NAME2=tngo25-webapi2-app
export IMAGE_VERSION=latest

export AWS_DEFAULT_REGION=us-east-2
export AWS_ECS_CLUSTER_NAME=default
export AWS_VIRTUAL_HOST=ec2-3-22-19-129.us-east-2.compute.amazonaws.com
export AWS_ACCOUNT_NUMBER=accountNumber
export AWS_ACCOUNT_USERNAME=username
export AWS_ACCOUNT_PWD=accountPwd

