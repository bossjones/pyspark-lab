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

# This module exports a set of functions corresponding to the intrinsic operators of Python.
# For example, operator.add(x, y) is equivalent to the expression x+y.  The function names are those used for special methods; variants without leading and trailing '__' are also provided for convenience.

from operator import add

from pyspark.sql import SparkSession

# source:
# https://stackoverflow.com/questions/41144218/pyspark-creating-a-data-frame-from-text-file

DEFAULT_TXT = "/home/jovyan/work/wordcount/app/sample_data.txt"

if __name__ == '__main__':
    # print("Usage: spark_streaming_txt.py <ip> <port> <txt>", file=sys.stderr)
    if len(sys.argv) != 2:
        print("Usage: spark_streaming_txt.py <file>", file=sys.stderr)
        exit(-1)

    # ***********************[DATAFRAME EXAMPLE]*************************************

    # TODO: Do we need this?
    # sc = SparkContext(appName="PythonStreamingTxt")
    # sc.setLogLevel("WARN")

    # NOTE: SparkSession - in-memory SparkContext
    spark = SparkSession\
        .builder\
        .appName("PythonWordCountTxt")\
        .getOrCreate()

    #######################
    # Lines setup - BEGIN
    #######################
    # Dataframes (Action) ... return: DataFrame[value: string]
    df_lines = spark.read.text(DEFAULT_TXT)

    # FIXME: Comment this in for real setup. df_lines = spark.read.text(sys.argv[1])

    # NOTE: pyspark.sql.dataframe.DataFrame
    type(df_lines)
    df_lines.count()

    # pyspark.rdd.PipelinedRDD (Transformation)
    lines = df_lines.rdd.map(lambda r: r[0])
    #######################
    # Lines setup - END
    #######################

    #######################
    # counts setup - BEGIN
    #######################
    # pyspark.rdd.PipelinedRDD
    flat_map_lines = lines.flatMap(lambda x: x.split(' '))
    type(flat_map_lines)

    # pyspark.rdd.PipelinedRDD
    flat_map_lines_transformed = flat_map_lines.map(lambda x: (x, 1))
    type(flat_map_lines_transformed)

    # pyspark.rdd.PipelinedRDD
    counts = flat_map_lines_transformed_reduced = flat_map_lines_transformed.reduceByKey(add)
    type(counts)

    # INFO: Previous
    # RawRDD
    # counts = lines.flatMap(lambda x: x.split(' ')) \
    #     .map(lambda x: (x, 1)) \
    #     .reduceByKey(add)

    #######################
    # counts setup - END
    #######################

    # NOTE: list of Tuples
    output = counts.collect()
    # [('field1', 1),
    #  ('', 11),
    #  ('field2', 1),
    #  ('field3', 1),
    #  ('field4', 1),
    #  ('0', 1),
    #  ('dog', 1),
    #  ('20160906182001', 1),
    #  ('google.com', 1),
    #  ('1', 1),
    #  ('cat', 1),
    #  ('20151231120504', 1),
    #  ('amazon.com', 1)]

    for (word, count) in output:
        print("%s: %i" % (word, count))
    # field1: 1
    # : 11
    # field2: 1
    # field3: 1
    # field4: 1
    # 0: 1
    # dog: 1
    # 20160906182001: 1
    # google.com: 1
    # 1: 1
    # cat: 1
    # 20151231120504: 1
    # amazon.com: 1

    spark.stop()
