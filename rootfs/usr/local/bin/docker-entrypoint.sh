#!/bin/sh

set -eo pipefail

AWSPATH="${AWSPATH:-$HOME/.aws}"
REGION="${REGION:-none}"
OUTPUT="${OUTPUT:-none}"

checkdir () {
  if [ ! -d "${AWSPATH}" ]; then
    echo "====== CREATE AWS DIR ======="
    mkdir -p ${AWSPATH}
  fi
}

checkvars() {
  if [ ! -z ${ACCESSKEY} ] && [ ! -z ${SECRETKEY} ] && [ ! -z ${REGION} ]; then
    checkdir
    tee ${AWSPATH}/credentials <<EOF
    [default]
    aws_access_key_id = ${ACCESSKEY}
    aws_secret_access_key = ${SECRETKEY}
EOF
    tee ${AWSPATH}/config <<EOF
    [default]
    region=${REGION}
    output=${OUTPUT}
EOF
  else
  aws configure
  fi
}

checkvars

exec "$@"
