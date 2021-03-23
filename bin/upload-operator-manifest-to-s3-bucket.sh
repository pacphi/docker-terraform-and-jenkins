#!/usr/bin/env bash

if [ -z "$1" ] && [ -z "$2" ] && [ -z "$3" ] && [ -z "$4" ]; then
	echo "Usage: upload-operator-manifest-to-s3-bucket.sh {path-to-manifest} {s3-bucket-name} {environment} {manifest-filename}"
	exit 1
fi

PATH_TO_MANIFEST="$1"
BUCKET_NAME="$2"
ENVIRONMENT="$3"
MANIFEST_FILENAME="$4"

cd "${PATH_TO_MANIFEST}" || exit 
aws s3 cp ${MANIFEST_FILENAME} s3://${BUCKET_NAME}/${ENVIRONMENT}/${MANIFEST_FILENAME}
aws s3api put-object --bucket ${BUCKET_NAME} --key ${ENVIRONMENT}/${MANIFEST_FILENAME} --server-side-encryption AES256
