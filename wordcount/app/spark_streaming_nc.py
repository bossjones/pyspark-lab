#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
[spark_streaming_nc]

Stream tweets via Twitter API tracking keywords.
"""

from pyspark import SparkContext
from pyspark.streaming import StreamingContext

# Step 1. First, we import StreamingContext, which is the main entry point
# for all streaming functionality. We create a local StreamingContext with
# 2 execution threads, and batch interval of 1 second.

# Create a local StreamingContext with two working thread and batch
# interval of 1 second
sc = SparkContext("local[2]", "NetworkWordCount")
ssc = StreamingContext(sc, 1)

# Step 2. Using this context, we can create a DStream that represents
# streaming data from a TCP source, specified as hostname (e.g. localhost)
# and port (e.g. 9999).

# Create a DStream that will connect to hostname:port, like localhost:9999
lines = ssc.socketTextStream("localhost", 9999)

# Step 3. This lines DStream represents the stream of data that will be
# received from the data server. Each record in this DStream is a line of
# text. Next, we want to split the lines by space into words.

# Split each line into words
words = lines.flatMap(lambda line: line.split(" "))

# Step 4. flatMap is a one-to-many DStream operation that creates a new
# DStream by generating multiple new records from each record in the
# source DStream. In this case, each line will be split into multiple
# words and the stream of words is represented as the words DStream. Next,
# we want to count these words.

# Count each word in each batch
pairs = words.map(lambda word: (word, 1))
wordCounts = pairs.reduceByKey(lambda x, y: x + y)

# Print the first ten elements of each RDD generated in this DStream to
# the console
wordCounts.pprint()

# Step 5. The words DStream is further mapped (one-to-one transformation)
# to a DStream of (word, 1) pairs, which is then reduced to get the
# frequency of words in each batch of data. Finally, wordCounts.pprint()
# will print a few of the counts generated every second.

# Note that when these lines are executed, Spark Streaming only sets up the computation it will perform when it is started, and no real processing has started yet. To start the processing after all the transformations have been setup, we finally call

ssc.start()             # Start the computation
ssc.awaitTermination()  # Wait for the computation to terminate

# Step 6. The complete code can be found in the Spark Streaming example
# NetworkWordCount.
# If you have already downloaded and built Spark, you can run this example as follows. You will first need to run Netcat(a small utility found in most Unix - like systems) as a data server by using

# $ nc -lk 9999

# Step 7. Then, in a different terminal, you can start the example by using

# ./bin/spark-submit examples/src/main/python/streaming/network_wordcount.py localhost 9999
