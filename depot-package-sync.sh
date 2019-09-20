#!/bin/bash
set -e

export HAB_NOCOLORING=true

if [ -z "$STUDIO_TYPE" ]; then
  echo "Must be run from studio"
  exit 1
fi

OPTS=`getopt -o t:u:p: --longoptions onprem-token:,onprem-url:,package: -n 'parse-options' -- "$@"`

if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

eval set -- "$OPTS"

TOKEN=''
URL=''
PACKAGE=''

while true; do
  case "$1" in
    -t | --onprem-token ) TOKEN="$2"; shift; shift ;;
    -u | --onprem-url )     URL="$2"; shift; shift ;;
    -p | --package )    PACKAGE="$2"; shift; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [ -z "$TOKEN" ] || [ -z "$URL" ] || [ -z "$PACKAGE" ]; then
  echo "Usage:"
  echo "$0 --onprem-token <token> --onprem-url https://<url> --package <package ident>"
  exit 1
fi

echo "Setting Public Env Vars"
export HAB_BLDR_URL=https://bldr.habitat.sh
export HAB_ORIGIN=core
unset HAB_AUTH_TOKEN

echo "Downloading ${PACKAGE}"
OUTPUT=$(hab pkg install ${PACKAGE} | tee /dev/tty)
P_IDENT=$(echo ${OUTPUT} | grep 'Install of' | sed -r 's/.*Install of (.*) complete.*/\1/')
if [ -z "${P_IDENT}" ]; then
  echo "Download Failed"
  exit 1
fi
echo "Downloaded to ${P_IDENT}"
P_ORIGIN=$(echo $P_IDENT | awk -F/ '{print $1}')
P_PACKAGE=$(echo $P_IDENT | awk -F/ '{print $2}')
P_VERSION=$(echo $P_IDENT | awk -F/ '{print $3}')
P_STAMP=$(echo $P_IDENT | awk -F/ '{print $4}')
P_FN="${P_ORIGIN}-${P_PACKAGE}-${P_VERSION}-${P_STAMP}*"
cd /hab/cache/artifacts
P_PATH=$(ls $P_FN)

echo "Setting Private Env Vars"
export HAB_BLDR_URL="${URL}"
export HAB_ORIGIN=core
export HAB_AUTH_TOKEN="${TOKEN}"

echo "Uploading /hab/cache/artifacts/${P_PATH}"
hab pkg upload "${P_PATH}"