#!/bin/bash

# @name terraform-destroy.sh
# @description This script invokes terraform destroy using a pre-configured Docker container image.
# @assumptions You have installed Docker
# @see https://www.vic-l.com/terraform-with-docker and https://blog.elreydetoda.site/docker-terraform/ 
# @author Chris Phillipson
# @version 1.0.0

DOCKER_CONTAINER_IMAGE_PREFIX="hashicorp/terraform"
DOCKER_CONTAINER_IMAGE_VERSION="0.14.5"
DOCKER_CONTAINER_IMAGE="${DOCKER_CONTAINER_IMAGE_PREFIX}:${DOCKER_CONTAINER_IMAGE_VERSION}"

TFVARS_FILE=${PWD}/terraform.tfvars
TFVARS_TMP=${PWD}/tfvars.tmp

if [ -f "$TFVARS_FILE" ]; then
  while IFS= read line
  do
    # Replace occurences of " = " with "=" inside terraform.tfvars
    # and prefix each line with "-e TF_VAR_"
    echo "-e TF_VAR_${line// = /=} " >> $TFVARS_TMP
  done <"$TFVARS_FILE"

  # Replace all newlines with spaces and squirrel results away to be consumed
  # as environment variables
  TFVARS=$(cat $TFVARS_TMP | tr '\n' ' ')
  rm -f $TFVARS_TMP
  
  # Destroy everything
  docker run -i --rm --name terraform -v ${PWD}:/workspace -w /workspace ${DOCKER_CONTAINER_IMAGE} "${1}" destroy -auto-approve -state /workspace/terraform.tfstate /workspace/
else 
  echo "[terraform destroy] could could not be executed because module did not include terraform.tfvars"
fi
