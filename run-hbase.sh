#!/bin/bash

current_dir=$(pwd)

. "${current_dir}/network.sh"

NETWORK=delegation-token-network
create_network_if_not_exists "${NETWORK}"
docker run -it --hostname=hbase --name=hbase --network "${NETWORK}" --rm --mount type=bind,source="${HOME}"/share,target=/share -p 2181:2181 -p 16000:16000 -p 16010:16010 -p 16020:16020 -p 16030:16030 gaborgsomogyi/hbase:latest
