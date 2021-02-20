#!/bin/sh

bold='\033[1;37m'
norm='\033[0m'
red='\033[0;31m'

i=0
LOGLINE="all dependencies initialized. starting workers"
while [ "${i}" -lt 30 ]; do
  i=$(( i+1 ))
  
  if [ -z "$(grep "${LOGLINE}" envoy.log)" ]; then
    echo "LOGLINE was not found yet..."
    # sleep 5
    # continue
  else
    echo "LOGLINE found!"
    date
  fi

  CERT=$(wget -qO- http://localhost:9901/certs | grep ${1})

  if [ -z "${CERT}" ]; then
    echo "${2}'s envoy is not ready yet, sleeping for a while..."
    sleep 5
    continue
  fi

  echo -e "${bold}${2}'s envoy is ready!${norm}"
  date
  ENVOY_READY=true
  break
done

if [ -z "${ENVOY_READY}" ]; then
  echo -e "${red}Timed out waiting for ${2}'s envoy${norm}"
  exit 1
fi
exit 0
