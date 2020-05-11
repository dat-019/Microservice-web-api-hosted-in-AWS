#!/bin/bash

# set environment variables used in deploy.sh and AWS task-definition.json:
export IMAGE_NAME2=tngo25-webapi2-app
export IMAGE_VERSION=latest

export AWS_DEFAULT_REGION=us-east-2
export AWS_ECS_CLUSTER_NAME=default
export AWS_VIRTUAL_HOST=ec2-3-22-19-129.us-east-2.compute.amazonaws.com
export AWS_ACCOUNT_NUMBER=accountNumber
export AWS_ACCOUNT_USERNAME=accountUserName
export AWS_ACCOUNT_PWD=accountPwd

export AWS_ACCESS_KEY_ID=accessKeyId
export AWS_SECRET_ACCESS_KEY=secrectAccessKey
