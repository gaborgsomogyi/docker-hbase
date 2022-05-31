#!/bin/bash

export JAVA_HOME=$(ls -d /usr/lib/jvm/java-1.8.0-openjdk*)
echo "Detected JAVA_HOME=$JAVA_HOME"

echo "export JAVA_HOME=${JAVA_HOME}" >> "${HBASE_HOME}/conf/hbase-env.sh"

cp /share/krb5.conf /etc

service ssh start
"${ZOOKEEPER_HOME}/bin/zkServer.sh" start
"${HBASE_HOME}/bin/start-hbase.sh"

while true; do sleep infinity; done
