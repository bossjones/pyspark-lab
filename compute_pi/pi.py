#!/usr/bin/env python3

import os
# make sure pyspark tells workers to use python3 not 2 if both are installed
os.environ['PYSPARK_PYTHON'] = '/usr/bin/python3'

import pyspark
conf = pyspark.SparkConf()

# point to mesos master or zookeeper entry (e.g., zk://10.10.10.10:2181/mesos)
conf.setMaster("zk://127.0.0.1:2181/mesos")
# point to spark binary package in HDFS or on local filesystem on all slave
# nodes (e.g., file:///opt/spark/spark-2.2.0-bin-hadoop2.7.tgz)
conf.set("spark.executor.uri", "hdfs://10.122.193.209/spark/spark-2.2.0-bin-hadoop2.7.tgz")
# set other options as desired
conf.set("spark.executor.memory", "1g")
conf.set("spark.core.connection.ack.wait.timeout", "1200")

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
