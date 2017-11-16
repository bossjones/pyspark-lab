FROM behance/docker-base:2.0.1

LABEL Maintainer="Malcolm Jones <bossjones@theblacktonystark.com>"

EXPOSE 8080 8082

#ENV MESOS_VERSION=1.0.1-2.0.94.ubuntu1604

# make the "en_US.UTF-8" locale so everything will be utf-8 enabled by default
# source: https://github.com/docker-library/postgres/blob/69bc540ecfffecce72d49fa7e4a46680350037f9/9.6/Dockerfile#L21-L24
RUN apt-get update && \
    apt-get install -y locales && \
    apt-get install -yqq --no-install-recommends \
    bzip2 \
    unzip \
    xz-utils \
    wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion \
      && \
    rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# source: https://github.com/docker-library/openjdk/blob/a893fe3cd82757e7bccc0948c88bfee09bd916c3/8-jre/Dockerfile
# Default to UTF-8 file.encoding
# ENV LANG C.UTF-8

ENV LANG en_US.utf8

# 2.1.0-2.2.0-1-hadoop-2.6
ENV LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  NOT_ROOT_USER=pi \
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

# Additional source: https://hub.docker.com/r/continuumio/miniconda3/~/dockerfile/


# Upgrade base security packages, then clean packaging leftover
RUN set -x mkdir -p /usr/share/man/man1 && \
  env \
  /bin/bash -e /security_updates.sh && \
  apt-get update -yqq && \
  apt-get upgrade -yqq && \
  apt-get install -yqq \
  openjdk-8-jre \
  unzip \
  curl \
  && \
  # miniconda3
  echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
  wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.27-Linux-x86_64.sh -O ~/miniconda.sh && \
  /bin/bash ~/miniconda.sh -b -p /opt/conda && \
  rm ~/miniconda.sh && \
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


ENV PATH /opt/conda/bin:$PATH

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
