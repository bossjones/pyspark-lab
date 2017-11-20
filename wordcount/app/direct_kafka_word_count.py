#!/usr/bin/env python

# source: https://community.hortonworks.com/articles/81359/pyspark-streaming-wordcount-example.html

# from pyspark.streaming import StreamingContext
# batchIntervalSeconds = 10

# def creatingFunc():
#   ssc = StreamingContext(sc, batchIntervalSeconds)
#   # Set each DStreams in this context to remember RDDs it generated in the last given duration.
#   # DStreams remember RDDs only for a limited duration of time and releases them for garbage
#   # collection. This method allows the developer to specify how long to remember the RDDs (
#   # if the developer wishes to query old data outside the DStream computation).
#   ssc.remember(60)

#   lines = ssc.textFileStream("YOUR_S3_PATH_HERE")
#   lines.pprint()

#   words = lines.flatMap(lambda line: line.split(","))
#   pairs = words.map(lambda word: (word, 1))
#   wordCounts = pairs.reduceByKey(lambda x, y: x + y)

#   def process(time, rdd):
#     df = sqlContext.createDataFrame(rdd)
#     df.registerTempTable("myCounts")

#   wordCounts.foreachRDD(process)

#   return ssc

# *****************************************************************************************

from pyspark.sql import SparkSession
from pyspark.sql.functions import explode
from pyspark.sql.functions import split

spark = SparkSession \
    .builder \
    .appName("StructuredNetworkWordCount") \
    .getOrCreate()


# *****************************************************************************************

# Create DataFrame representing the stream of input lines from connection to localhost:9999
lines = spark \
    .readStream \
    .format("socket") \
    .option("host", "localhost") \
    .option("port", 9999) \
    .load()

# Split the lines into words
words = lines.select(
   explode(
       split(lines.value, " ")
   ).alias("word")
)

# Generate running word count
wordCounts = words.groupBy("word").count()
