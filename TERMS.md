# General Terms #

# Serialization:

**Seralization:** Serialization is a process of converting an object into a sequence of bytes which can be persisted to a disk or database or can be sent through streams

**Deserialization:** The reverse process of seralization, creating object from sequence of bytes.


# Spark Terms General #

**Transformations:** which create a new dataset from an existing one, and actions, which return a value to the driver program after running a computation on the dataset.

# Spark Core Classes #

**pyspark.SparkContext:** Main entry point for Spark functionality.

**pyspark.RDD:** A Resilient Distributed Dataset (RDD), the basic abstraction in Spark.

**pyspark.streaming.StreamingContext:** Main entry point for Spark Streaming functionality.

**pyspark.streaming.DStream:** A Discretized Stream (DStream), the basic abstraction in Spark Streaming.

**pyspark.sql.SQLContext:** Main entry point for DataFrame and SQL functionality.

**pyspark.sql.DataFrame:** A distributed collection of data grouped into named columns. Really a Dataset[Row], but called Dataframe to be consistent with the data frame concept in Pandas and R.

**pyspark.SparkContext.parallelize(c, numSlices=None):** Distribute a local Python collection to form an RDD. Using xrange is recommended if the input represents a range for performance.

**EG.**

```
>>> sc.parallelize([0, 2, 3, 4, 6], 5).glom().collect()
[[0], [2], [3], [4], [6]]
>>> sc.parallelize(xrange(0, 6, 2), 5).glom().collect()
[[], [0], [], [2], [4]]
```
