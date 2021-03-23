#!/usr/bin/env bash

if [ -z "$1" ]; then
	echo "Usage: initialize-s3-buckets.sh {suffix}"
	exit 1
fi

SUFFIX="$1"

aws s3 mb s3://terraform-vars-${SUFFIX}
aws s3 mb s3://terraform-secrets-${SUFFIX}
aws s3 mb s3://terraform-state-${SUFFIX}

aws s3api put-bucket-versioning --bucket terraform-vars-${SUFFIX} --versioning-configuration Status=Enabled
aws s3api put-bucket-versioning --bucket terraform-secrets-${SUFFIX} --versioning-configuration Status=Enabled
aws s3api put-bucket-versioning --bucket terraform-state-${SUFFIX} --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
    --bucket terraform-vars-${SUFFIX} \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

aws s3api put-bucket-encryption \
    --bucket terraform-secrets-${SUFFIX} \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'
