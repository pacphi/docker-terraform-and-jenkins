#!/bin/bash

# @name terraform-apply.sh
# @description This script invokes terraform apply using a pre-configured Docker container image.
# @assumptions You have installed Docker
# @see https://www.vic-l.com/terraform-with-docker and https://blog.elreydetoda.site/docker-terraform/ 
# @author Chris Phillipson
# @version 1.0.0

DOCKER_CONTAINER_IMAGE_PREFIX="hashicorp/terraform"
DOCKER_CONTAINER_IMAGE_VERSION="0.14.5"
DOCKER_CONTAINER_IMAGE="${DOCKER_CONTAINER_IMAGE_PREFIX}:${DOCKER_CONTAINER_IMAGE_VERSION}"
  
# Apply the plan and capture state
docker run -i --rm --name terraform -v ${PWD}:/workspace -w /workspace ${DOCKER_CONTAINER_IMAGE} "${1}" apply -state /workspace/terraform.tfstate /workspace/terraform.plan
