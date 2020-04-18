#!/bin/bash

set -e
set -o pipefail

if [ "${S3_ACCESS_KEY_ID}" = "**None**" ]; then
  echo "You need to set the S3_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ "${S3_SECRET_ACCESS_KEY}" = "**None**" ]; then
  echo "You need to set the S3_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ "${S3_BUCKET}" = "**None**" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ "${SOURCE_DIR}" = "**None**" ]; then
  echo "You need to set the SOURCE_DIR environment variable."
  exit 1
fi

if [ "${TARGET_DIR}" = "**None**" ]; then
  echo "You need to set the TARGET_DIR environment variable."
  exit 1
fi

if [ "${FILE_NAME}" = "**None**" ]; then
  echo "You need to set the FILE_NAME environment variable."
  exit 1
fi

# Check if endpoint url is set
if [ "${S3_ENDPOINT}" == "**None**" ]; then
  AWS_ARGS=""
else
  AWS_ARGS="--endpoint-url ${S3_ENDPOINT}"
fi

# env vars needed for aws tools
export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION

echo "creating archive..."

# this has to be executed like this, because we have two level expansion in variables
eval "export BACKUP_DST_FULL_PATH=${TARGET_DIR}/${FILE_NAME}.tar.gz"

BACKUP_DST_DIR=$(dirname "${BACKUP_DST_FULL_PATH}")

mkdir -p ${BACKUP_DST_DIR}
echo "Gzipping ${SOURCE_DIR} into ${BACKUP_DST_FULL_PATH}"

tar -czf ${BACKUP_DST_FULL_PATH} -C ${SOURCE_DIR} .
cp ${BACKUP_DST_FULL_PATH} latest.tar.gz


echo "archive created, uploading..."
cat ${BACKUP_DST_FULL_PATH} | aws $AWS_ARGS s3 cp - s3://${S3_BUCKET}${BACKUP_DST_FULL_PATH} || exit 2
cat ${BACKUP_DST_FULL_PATH} | aws $AWS_ARGS s3 cp - s3://${S3_BUCKET}/backup/content/backup_latest.tar.gz || exit 2


echo "backup finished"
