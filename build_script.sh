#!/bin/bash

AWS_CLI_REPO_VAR="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"

KUBECTL_VERSION_VAR="1.32.0/2024-12-20"

DOCKER_REPO="aws-build"
DOCKER_TAG="test"

EKSCTL_PLATFORM_VAR="linux_amd64"

docker build . -t ${DOCKER_REPO}:${DOCKER_TAG} --build-arg AWS_CLI_REPO=${AWS_CLI_REPO_VAR} --build-arg KUBECTL_VERSION=${KUBECTL_VERSION_VAR} --build-arg EKSCTL_PLATFORM=${EKSCTL_PLATFORM_VAR}

docker run --rm ${DOCKER_REPO}:${DOCKER_TAG} 

