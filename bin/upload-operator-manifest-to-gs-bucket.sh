#!/usr/bin/env bash

if [ -z "$1" ] && [ -z "$2" ] && [ -z "$3" ] && [ -z "$4" ]; then
	echo "Usage: upload-operator-manifest-to-gs-bucket.sh {path-to-manifest} {gs-bucket-name} {environment} {manifest-filename}"
	exit 1
fi

PATH_TO_MANIFEST="$1"
BUCKET_NAME="$2"
ENVIRONMENT="$3"
MANIFEST_FILENAME="$4"

cd "${PATH_TO_MANIFEST}" || exit 
gsutil cp ${MANIFEST_FILENAME} gs://${BUCKET_NAME}/${ENVIRONMENT}/${MANIFEST_FILENAME}
