#!/bin/bash

create_network_if_not_exists () {
  local NETWORK=$1
  local EXISTING_NETWORK
  EXISTING_NETWORK=$(docker network ls | grep "${NETWORK}")
  if [ -z "${EXISTING_NETWORK}" ]
  then
    echo "Network ${NETWORK} is missing, creating it"
    docker network create "${NETWORK}"
  else
    echo "Network ${NETWORK} already exists"
  fi
}
