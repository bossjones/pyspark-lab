#!/usr/bin/env python

import os
# make sure pyspark tells workers to use python3 not 2 if both are installed
os.environ['PYSPARK_PYTHON'] = '/usr/bin/python3'

HOST_IP = os.getenv("HOST_IP")
LOCAL_REPOSITORY = "{}:5000".format(HOST_IP)

import pyspark
conf = pyspark.SparkConf()

# point to mesos master or zookeeper entry (e.g., zk://10.10.10.10:2181/mesos)
conf.setMaster("zk://127.0.0.1:2181/mesos")
# point to spark binary package in HDFS or on local filesystem on all slave
# nodes (e.g., file:///opt/spark/spark-2.2.0-bin-hadoop2.7.tgz)
# set other options as desired
conf.set("spark.executor.memory", "1g")
conf.set("spark.core.connection.ack.wait.timeout", "1200")
# conf.set("spark.executor.uri", "https://downloads.mesosphere.com/spark/assets/spark-2.1.0-1-bin-2.6.tgz")
conf.set("spark.mesos.executor.home", "/opt/spark/dist")

conf.set("spark.executor.cores", "1")
conf.set("spark.cores.max", "2")
# conf.set("spark.mesos.constraints", "")
# conf.set("spark.mesos.principal", "")
# conf.set("spark.mesos.secret", "")
# conf.set("spark.mesos.uris", "")
# conf.set("spark.mesos.executor.docker.volumes", "")
# if [ -n "$UI_PORT" ]; then
#     SPARK_OPTS="$SPARK_OPTS --conf spark.ui.port=$UI_PORT"
#   elif [ -n "$PORT0" ]; then
#     SPARK_OPTS="$SPARK_OPTS --conf spark.ui.port=$PORT0"
#   fi

CONTAINER_TAG = "{}/{}".format(HOST_IP,"bossjones/pi-spark-lab:latest")

conf.set("spark.mesos.executor.docker.image", CONTAINER_TAG)
conf.set("spark.ui.port", "$PORT0")

conf.set("spark.executor.memory", "1g")
conf.set("spark.executor.extraJavaOptions", "-XX:+PrintGCDetails -XX:+PrintGCTimeStamps")

# from local marathon vars
conf.set("spark.executorEnv.SPARK_DRIVER_CORES", "1")
conf.set("spark.executorEnv.SPARK_EXECUTOR_MEMORY", "1g")
conf.set("spark.executorEnv.MESOS_EXECUTOR_DOCKER_IMAGE", CONTAINER_TAG)
conf.set("spark.executorEnv.APPLICATION_WEB_PROXY_BASE", "/service/bossjones-pyspark-lab")
conf.set("spark.executorEnv.SPARK_DRIVER_MEMORY", "1g")
conf.set("spark.executorEnv.APP_NAME", "bossjones-pyspark-lab")
conf.set("spark.executorEnv.SPARK_DYNAMIC_ALLOCATION_MAX_EXECUTORS", "1")
# conf.set("spark.executorEnv.SPARK_SUBMIT_SCRIPT_PATH", "/app/scripts/spark-submit-model.sh")
conf.set("spark.executorEnv.CFG_DB_STATS_HOST", "127.0.0.1")
conf.set("spark.executorEnv.SPARK_CORES_MAX", "4")
conf.set("spark.executorEnv.SPARK_EXECUTOR_CORES", "1")
conf.set("spark.executorEnv.MASTER_URI", "zk://127.0.0.1:2181/mesos")
conf.set("spark.executorEnv.MESOS_MASTER_URI", "zk://127.0.0.1:2181/mesos")
conf.set("spark.executorEnv.SPARK_PUBLIC_DNS", HOST_IP)
conf.set("spark.executorEnv.CFG_DB_NETWORK_HOST", "127.0.0.1")
conf.set("spark.executorEnv.LIBPROCESS_IP", HOST_IP)

#  --conf "spark.executor.extraJavaOptions=-XX:+PrintGCDetails -XX:+PrintGCTimeStamps"

# create the context
sc = pyspark.SparkContext(conf=conf)

# do something to prove it works
rdd = sc.parallelize(range(100000000))
rdd.sumApprox(3)


# -------------------
# from __future__ import print_function

# import sys
# from random import random
# from operator import add

# from pyspark.sql import SparkSession


# if __name__ == "__main__":
#     """
#         Usage: pi [partitions]
#     """
#     spark = SparkSession\
#         .builder\
#         .appName("PythonPi")\
#         .getOrCreate()

#     partitions = int(sys.argv[1]) if len(sys.argv) > 1 else 2
#     n = 100000 * partitions

#     def f(_):
#         x = random() * 2 - 1
#         y = random() * 2 - 1
#         return 1 if x ** 2 + y ** 2 <= 1 else 0

#     count = spark.sparkContext.parallelize(range(1, n + 1), partitions).map(f).reduce(add)
#     print("Pi is roughly %f" % (4.0 * count / n))

#     spark.stop()
# ------------------------------
