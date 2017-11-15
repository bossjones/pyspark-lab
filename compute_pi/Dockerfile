FROM mesosphere/spark:1.0.9-2.1.0-1-hadoop-2.6

ENV HADOOP_VERSION 2.6.0
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
ENV SPARK_HOME /opt/spark/dist
ENV SPARK_CONF_FILE $SPARK_HOME/conf/spark-defaults.conf
ENV LD_LIBRARY_PATH "${HADOOP_HOME}/lib/native:${LD_LIBRARY_PATH}"

RUN curl -sL --retry 3 \
  "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
  | gunzip \
  | tar -x -C /usr/ \
 && rm -rf $HADOOP_HOME/share/doc \
 && chown -R root:root $HADOOP_HOME

COPY ./conf $SPARK_HOME/conf
