FROM ubuntu:jammy

EXPOSE 2181 16000 16010 16020 16030

RUN apt-get -qq update
RUN apt-get -qq install curl ssh openjdk-8-jdk krb5-user nmap
RUN apt-get -qq clean

ENV ZOOKEEPER_VERSION 3.5.7
ENV HBASE_VERSION 2.4.15
ENV ZOOKEEPER_HOME /opt/zookeeper
ENV HBASE_HOME /opt/hbase

ADD ssh_config /root/.ssh/config
RUN \
  ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

RUN \
  curl -s "https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz" | tar -xz -C /opt && \
  ln -s "/opt/apache-zookeeper-${ZOOKEEPER_VERSION}-bin" "${ZOOKEEPER_HOME}"

ADD zoo.cfg "${ZOOKEEPER_HOME}/conf/zoo.cfg"
ADD zookeeper_jaas.conf "${ZOOKEEPER_HOME}/conf/"

RUN echo "export SERVER_JVMFLAGS=\"$SERVER_JVMFLAGS -Djava.security.auth.login.config=${ZOOKEEPER_HOME}/conf/zookeeper_jaas.conf\"" >> "${ZOOKEEPER_HOME}/bin/zkEnv.sh"

RUN \
  curl -s "https://dlcdn.apache.org/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz" | tar -xz -C /opt && \
  ln -s "/opt/hbase-${HBASE_VERSION}" "${HBASE_HOME}"

ADD *.xml "${HBASE_HOME}/conf/"
ADD hbase_jaas.conf "${HBASE_HOME}/conf/"

RUN sed -i -e 's/hbase.root.logger=.*/hbase.root.logger=TRACE,console/' "${HBASE_HOME}/conf/log4j.properties"
RUN sed -i -e 's/hbase.security.logger=.*/hbase.security.logger=TRACE,console/' "${HBASE_HOME}/conf/log4j.properties"
RUN sed -i -e 's/hbase.log.level=.*/hbase.log.level=TRACE/' "${HBASE_HOME}/conf/log4j.properties"

RUN \
    echo "export HBASE_MANAGES_ZK=false" >> "${HBASE_HOME}/conf/hbase-env.sh" && \
    echo "export HBASE_OPTS=\"-Dsun.security.krb5.debug=true -Djava.security.auth.login.config=${HBASE_HOME}/conf/hbase_jaas.conf\"" >> "${HBASE_HOME}/conf/hbase-env.sh" && \
    echo "export HBASE_MASTER_OPTS=\"-Dsun.security.krb5.debug=true -Djava.security.auth.login.config=${HBASE_HOME}/conf/hbase_jaas.conf\"" >> "${HBASE_HOME}/conf/hbase-env.sh" && \
    echo "export HBASE_REGIONSERVER_OPTS=\"-Dsun.security.krb5.debug=true -Djava.security.auth.login.config=${HBASE_HOME}/conf/hbase_jaas.conf\"" >> "${HBASE_HOME}/conf/hbase-env.sh"

RUN mkdir -p /opt/hbase/data/hbase && chmod 777 /opt/hbase/data/hbase

ADD init-script.sh /init-script.sh
ENTRYPOINT /init-script.sh
