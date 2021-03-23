#!/usr/bin/env bash

if [ -z "$1" ] && [ -z "$2" ]; then
	echo "Usage: initialize-gs-buckets.sh {location} {suffix}"
	exit 1
fi

LOCATION="$1"
SUFFIX="$2"

gsutil mb -l ${LOCATION} gs://terraform-vars-${SUFFIX}
gsutil mb -l ${LOCATION} gs://terraform-secrets-${SUFFIX}
gsutil mb -l ${LOCATION} gs://sa-credentials-${SUFFIX}

gsutil versioning set on gs://terraform-vars-${SUFFIX}
gsutil versioning set on gs://terraform-secrets-${SUFFIX}
gsutil versioning set on gs://sa-credentials-${SUFFIX}
