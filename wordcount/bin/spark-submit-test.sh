#!/usr/bin/env bash

set -e
set -x

# bin/spark-submit --jars external/kafka-assembly/target/scala-*/spark-streaming-kafka-assembly-*.jar /Users/ThomasVincent/Desktop/kafka_wordcount.py localhost:2181 test-topic

# Without this, only stdout would be captured - i.e. your
# log file would not contain any error messages.
# SEE (and upvote) the answer by Adam Spiers, which keeps STDERR
# as a separate stream - I did not want to steal from him by simply
# adding his answer to mine.
exec 2>&1

# bin/spark-submit --jars ${HADOOP_HOME}/share/hadoop/tools/lib/spark-streaming-kafka-assembly_2.11-1.6.3.jar

# source: https://github.com/kashirin-alex/environments-builder/blob/b2bb2adda787d7a34809061a175baf69406d2477/debian/build-debian-env.sh
# 'apache-hadoop')
# fn='hadoop-2.7.3.tar.gz'; tn='hadoop-2.7.3'; url='http://apache.crihan.fr/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz';
# set_source 'tar'
# if [ -d $CUST_JAVA_INST_PREFIX/$sn ]; then
# 	rm -r $CUST_JAVA_INST_PREFIX/$sn;
# else
# 	if [ ! -d /etc/opt/hadoop ]; then
# 		mv $CUST_JAVA_INST_PREFIX/$sn/etc/hadoop /etc/opt/;chmod -R 777 /etc/opt/hadoop;
# 	fi
# 	rm -r $CUST_JAVA_INST_PREFIX/$sn/etc/hadoop
# fi
# mv ../$sn $CUST_JAVA_INST_PREFIX/$sn;

# ln -s /etc/opt/hadoop $CUST_JAVA_INST_PREFIX/$sn/etc/hadoop

# echo "#!/usr/bin/env bash" > $ENV_SETTINGS_PATH/$sn.sh
# echo "export HADOOP_HOME=\"$CUST_JAVA_INST_PREFIX/$sn\"" >> $ENV_SETTINGS_PATH/$sn.sh
# echo "export HADOOP_CONF_DIR=\"$CUST_JAVA_INST_PREFIX/$sn/etc/hadoop\"" >> $ENV_SETTINGS_PATH/$sn.sh
# echo "export HADOOP_VERSION=\"2.7.3\"" >> $ENV_SETTINGS_PATH/$sn.sh
# echo "export HADOOP_INCLUDE_PATH=\"$CUST_JAVA_INST_PREFIX/$sn/include\"" >> $ENV_SETTINGS_PATH/$sn.sh
# echo "export HADOOP_LIB_PATH=\"$CUST_JAVA_INST_PREFIX/$sn/lib\"" >> $ENV_SETTINGS_PATH/$sn.sh
# echo "export PATH=\$PATH:\"$CUST_JAVA_INST_PREFIX/$sn/bin\"" >> $ENV_SETTINGS_PATH/$sn.sh
# 		shift;;


# FIXME: Mesos version 11/26/2017
# ${SPARK_HOME}/bin/spark-submit \
# --name ${APP_NAME} \
# --master ${MASTER_URI} \
# --deploy-mode client \
# --jars /jars/spark-streaming-kafka-assembly_2.11-1.6.3.jar \
# --py-files /app/app/kafka_wordcount.py \
# --verbose \
# /app/app/kafka_wordcount.py localhost:2181 test-topic

# FIXME: simple version
${SPARK_HOME}/bin/spark-submit \
--name pyspark-lab-kafka-test \
--jars /jars/spark-streaming-kafka-assembly_2.11-1.6.3.jar \
--verbose \
/app/app/kafka_wordcount.py ${DOCKERHOST}:32181 test
