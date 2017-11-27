#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Stream tweets via Twitter API tracking keywords."""
from __future__ import print_function

import os
import sys
from pyspark import SparkContext
from pyspark import SparkConf
from pyspark.sql import SQLContext
from pyspark.sql.context import SQLContext
from pyspark.sql.types import IntegerType, TimestampType

# source:
# https://stackoverflow.com/questions/41144218/pyspark-creating-a-data-frame-from-text-file

# KAFKA_CONF = {'bootstrap.servers': 'localhost:29092'}
# TOPIC = 'wordcount'
# LIMIT = 100
# PATH = ""
# COUNT = 0
# WORDS = []

if __name__ == '__main__':
    # if len(sys.argv) != 2:
    #     # print("Usage: kafka_wordcount.py <ip> <port> <txt>", file=sys.stderr)
    #     print("Usage: kafka_wordcount.py <txt>", file=sys.stderr)
    #     exit(-1)

    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------

    sc = SparkContext(appName="PythonStreamingKafkaWordCount")

    sc.setLogLevel("WARN")
    # setup the same way you have it
    # log_txt = sc.textFile("/usr/local/spark/sample_data.txt")
    log_txt = sc.textFile("/usr/local/spark/sample_data.txt")
    header = log_txt.first()

    # filter out the header, make sure the rest looks correct
    log_txt = log_txt.filter(lambda line: line != header)
    log_txt.take(10)
    #   [u'0\\tdog\\t20160906182001\\tgoogle.com', u'1\\tcat\\t20151231120504\\tamazon.com']

    temp_var = log_txt.map(lambda k: k.split("\\t"))

    print(temp_var)

    print(dir(temp_var))

    # here's where the changes take place
    # this creates a dataframe using whatever pyspark feels like using (I
    # think string is the default). the header.split is providing the names of
    # the columns
    log_df = temp_var.toDF(header.split("\\t"))
    log_df.show()
    # +------+------+--------------+----------+
    # |field1 | field2 | field3 | field4|
    # +------+------+--------------+----------+
    # |     0 | dog | 20160906182001 | google.com|
    # |     1 | cat | 20151231120504 | amazon.com|
    # +------+------+--------------+----------+
    # note log_df.schema
    # StructType(List(StructField(field1,StringType,true),StructField(field2,StringType,true),StructField(field3,StringType,true),StructField(field4,StringType,true)))

    # now lets cast the columns that we actually care about to dtypes we want
    log_df = log_df.withColumn("field1Int", log_df["field1"].cast(IntegerType()))
    log_df = log_df.withColumn("field3TimeStamp", log_df[
                            "field1"].cast(TimestampType()))

    log_df.show()
    # +------+------+--------------+----------+---------+---------------+
    # |field1 | field2 | field3 | field4 | field1Int | field3TimeStamp|
    # +------+------+--------------+----------+---------+---------------+
    # |     0 | dog | 20160906182001 | google.com | 0 | null|
    # |     1 | cat | 20151231120504 | amazon.com | 1 | null|
    # +------+------+--------------+----------+---------+---------------+
    # log_df.schema
    # StructType(List(StructField(field1, StringType, true), StructField(field2, StringType, true), StructField(field3, StringType, true),StructField(field4, StringType, true), StructField(field1Int, IntegerType, true), StructField(field3TimeStamp, TimestampType, true)))

    # now let's filter out the columns we want
    log_df.select(["field1Int", "field3TimeStamp", "field4"]).show()
    # +---------+---------------+----------+
    # |field1Int | field3TimeStamp | field4|
    # +---------+---------------+----------+
    # |        0 | null | google.com|
    # |        1 | null | amazon.com|
    # +---------+---------------+----------+

    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    # -------------------------------------------------------------------------
    # zkQuorum, topic = sys.argv[1:]
    # kvs = KafkaUtils.createStream(
    #     ssc, zkQuorum, "spark-streaming-consumer", {topic: 1})
    # lines = kvs.map(lambda x: x[1])
    # lines.pprint()

    # counts = lines.flatMap(lambda line: line.split(" ")) \
    #               .map(lambda word: (word, 1)) \
    #               .reduceByKey(lambda a, b: a + b)
    # counts.pprint()

    # ssc.start()
    # ssc.awaitTermination()
