#!/bin/bash

# @name terraform-destroy.sh
# @description This script invokes terraform destroy using a pre-configured Docker container image.
# @assumptions You have installed Docker
# @see https://www.vic-l.com/terraform-with-docker and https://blog.elreydetoda.site/docker-terraform/ 
# @author Chris Phillipson
# @version 1.0.0

DOCKER_CONTAINER_IMAGE_PREFIX="hashicorp/terraform"
DOCKER_CONTAINER_IMAGE_VERSION="0.14.8"
DOCKER_CONTAINER_IMAGE="${DOCKER_CONTAINER_IMAGE_PREFIX}:${DOCKER_CONTAINER_IMAGE_VERSION}"
  
# Destroy everything
docker run -i --rm --name terraform -v ${PWD}:/workspace -w /workspace ${DOCKER_CONTAINER_IMAGE} "${1}" destroy -auto-approve -state /workspace/terraform.tfstate /workspace/

