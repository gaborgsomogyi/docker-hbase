#!/bin/bash

cp /share/krb5.conf /etc

service ssh start
$ZOOKEEPER_HOME/bin/zkServer.sh start
$HBASE_HOME/bin/start-hbase.sh

while true; do sleep infinity; done
