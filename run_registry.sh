#!/bin/sh
# Check if credentials for running the container are set, if not
# abort with a message so that logs have the real reason why the
# container didn't start.
set -e

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    echo "No access key set, aborting..."
    exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "No secret access key set, aborting..."
    exit 1
fi

aws s3api get-object --bucket newstore-vault --key docker_registry/htpasswd /var/lib/registry/htpasswd

registry cmd/registry/config.yml
