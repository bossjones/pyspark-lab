FROM behance/docker-base:2.0.1

LABEL Maintainer="Malcolm Jones <bossjones@theblacktonystark.com>"

EXPOSE 8080 8082

#ENV MESOS_VERSION=1.0.1-2.0.94.ubuntu1604

# 2.1.0-2.2.0-1-hadoop-2.6
ENV NOT_ROOT_USER=pi \
  UID=1001 \
  JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
  SPARK_VERSION=2.2.0 \
  HADOOP_VERSION=2.8.0 \
  SPARK_HOME=/usr/local/spark \
  HADOOP_HOME=/usr/local/hadoop \
  SCRATCH_DIR=/mnt/scratch \
  SPARK_DIST_URL=https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz \
  HADOOP_DIST_URL=https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
  HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop \
  PATH=$PATH:$HADOOP_HOME/bin \
  SPARK_CONF_FILE=$SPARK_HOME/conf/spark-defaults.conf \
  LD_LIBRARY_PATH=${HADOOP_HOME}/lib/native:${LD_LIBRARY_PATH}

WORKDIR /

# Upgrade base security packages, then clean packaging leftover
RUN set -x mkdir -p /usr/share/man/man1 && \
  /bin/bash -e /security_updates.sh && \
  apt-get upgrade -yqq && \
  apt-get install -yqq \
  openjdk-8-jre \
  unzip \
  curl \
  && \
  # https://github.com/anapsix/docker-alpine-java/issues/18#issue-167437838
  # If you want to change the default values here, also change the values in 042-set-jvm-ttl.sh
  sed -i s/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=10/ ${JAVA_HOME}/jre/lib/security/java.security && \
  sed -i s/networkaddress.cache.negative.ttl=10/networkaddress.cache.negative.ttl=0/ ${JAVA_HOME}/jre/lib/security/java.security && \
  # Add non root user
  adduser --system --disabled-password --uid ${UID} --home /home/${NOT_ROOT_USER} --shell /bin/bash ${NOT_ROOT_USER} && \
  # mesos setup
  echo "deb http://repos.mesosphere.io/ubuntu/ xenial main" > /etc/apt/sources.list.d/mesosphere.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E56151BF && \
  apt-get -y update && \
  apt-get -y install mesos curl && \
  apt-get clean && rm -rf /var/lib/apt/lists/* && \
  apt-get -y purge zookeeper zookeeper-bin zookeeperd && \
  # Install spark and hadoop
  mkdir -p ${SPARK_HOME} && \
  curl --retry 3 -sSL ${SPARK_DIST_URL} \
  | tar -xz -C ${SPARK_HOME} --strip-components 1 && \
  echo 'SPARK_DIST_CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath):$HADOOP_HOME/share/hadoop/tools/lib/*' >> ${SPARK_HOME}/conf/spark-env.sh && \
  echo 'SPARK_LOCAL_DIRS=$SCRATCH_DIR/spark' >> ${SPARK_HOME}/conf/spark-env.sh && \
  # getting full hadoop distribution for now and removing some of the larger items
  # could be more selective if size is a concern
  mkdir -p ${HADOOP_HOME} && \
  curl --retry 3 -sSL ${HADOOP_DIST_URL} \
  | tar -xz -C ${HADOOP_HOME} --strip-components 1 && \
  rm -rf ${HADOOP_HOME}/share/doc && \
  find /usr/local/hadoop -name '*source*.jar' -o -name '*test*.jar' | xargs rm -f && \
  chown -Rv root:root $HADOOP_HOME && \
  # Clean up
  apt-get remove --purge -yq \
  unzip \
  curl \
  && \
  /bin/bash /clean.sh

# TODO: Do I need this?
# ENV HADOOP_VERSION 2.6.0
# ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
# ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
# ENV PATH $PATH:$HADOOP_HOME/bin
# ENV SPARK_HOME /opt/spark/dist
# ENV SPARK_CONF_FILE $SPARK_HOME/conf/spark-defaults.conf
# ENV LD_LIBRARY_PATH "${HADOOP_HOME}/lib/native:${LD_LIBRARY_PATH}"

# RUN curl -sL --retry 3 \
#   "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
#   | gunzip \
#   | tar -x -C /usr/ \
#   && rm -rf $HADOOP_HOME/share/doc \
#   && chown -R root:root $HADOOP_HOME

# COPY ./conf $SPARK_HOME/conf

# Overlay the root filesystem from this repo
COPY ./container/root /

RUN goss -g /tests/spark/ubuntu.goss.yaml validate

# needed by spark service
WORKDIR ${SPARK_HOME}
