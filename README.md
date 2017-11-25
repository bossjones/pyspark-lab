# pyspark-lab
Scripts to try out pyspark with. Use with https://github.com/jupyter/docker-stacks/tree/master/pyspark-notebook

# Spark-practice
- https://github.com/XD-DENG/Spark-practice
- https://github.com/mahmoudparsian/pyspark-tutorial
- https://github.com/svenkreiss/pysparkling
- https://github.com/ksindi/kafka-pyspark-demo
- https://github.com/confluentinc/cp-docker-images/wiki/Getting-Started
- https://docs.confluent.io/current/connect/managing.html

- http://activisiongamescience.github.io/2016/06/15/Kafka-Client-Benchmarking/
# kafkacat
*https://github.com/edenhill/kafkacat*

```
# see info about your image
docker run --rm kafkacat
# produce stuff (Ctrl+C to exit)
echo "msg 1" | docker run -i --rm --net=host kafkacat -b mybroker -t logs -P
# consume stuff (Ctrl+C to exit)
docker run --rm -t --net=host kafkacat -b mybroker -t logs -C
# produce from file or command inside the container
echo 1 > example.log
docker run --name test-producer -d -v $(pwd)/example.log:/logs/example.log --entrypoint /bin/bash --net=host kafkacat \
  -c 'tail -f /logs/example.log | kafkacat -b mybroker -t logs -P'
echo 2 >> example.log
# the last example runs in background so clean up
docker kill test-producer && docker rm test-producer
```



# remote-jmx-with-docker

https://ptmccarthy.github.io/2014/07/24/remote-jmx-with-docker/

```
An important Docker-related note about the Tomcat configuration above is that the -Djava.rmi.server.hostname must be set to the externally accessible IP address of the Tomcat server. You want to use the address of the Docker host, not the Docker-assigned internal IP address.
```


# troubleshooting host networking on zookeeper ( Should see something like this )

```
[2017-11-24 03:31:32,185] INFO Server environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib (org.apache.zookeeper.server.ZooKeeperServer)
[2017-11-24 03:31:32,185] INFO Server environment:java.io.tmpdir=/tmp (org.apache.zookeeper.server.ZooKeeperServer)
[2017-11-24 03:31:32,185] INFO Server environment:java.compiler=<NA> (org.apache.zookeeper.server.ZooKeeperServer)
[2017-11-24 03:31:32,185] INFO Server environment:os.name=Linux (org.apache.zookeeper.server.ZooKeeperServer)
[2017-11-24 03:31:32,185] INFO Server environment:os.arch=amd64 (org.apache.zookeeper.server.ZooKeeperServer)
[2017-11-24 03:31:32,185] INFO Server environment:os.version=4.4.17-boot2docker (org.apache.zookeeper.server.ZooKeeperServer)
[2017-11-24 03:31:32,185] INFO Server environment:user.name=root (org.apache.zookeeper.server.ZooKeeperServer)
[2017-11-24 03:31:32,185] INFO Server environment:user.home=/root (org.apache.zookeeper.server.ZooKeeperServer)
[2017-11-24 03:31:32,185] INFO Server environment:user.dir=/ (org.apache.zookeeper.server.ZooKeeperServer)
[2017-11-24 03:31:32,195] INFO tickTime set to 2000 (org.apache.zookeeper.server.ZooKeeperServer)
[2017-11-24 03:31:32,195] INFO minSessionTimeout set to -1 (org.apache.zookeeper.server.ZooKeeperServer)
[2017-11-24 03:31:32,195] INFO maxSessionTimeout set to -1 (org.apache.zookeeper.server.ZooKeeperServer)
[2017-11-24 03:31:32,206] INFO binding to port 0.0.0.0/0.0.0.0:32181 (org.apache.zookeeper.server.NIOServerCnxnFactory)
```


# Monitoring (pyspark)

- https://github.com/JasonMWhite/spark-datadog-relay
- https://github.com/jvutukur/Data-Visualization
- https://github.com/wangcunxin/wespark/blob/58805b88bb56c27d4116f5bf3e1efdd861798f1d/bblink/graphite/kafka_graphite_streaming.py
- https://github.com/hopshadoop/hops-yarn-ML/blob/7e54f12bafeaae62fde40eb6a18ebcac4a6f5e9e/yarn_machine_learning.py
- https://tlfvincent.github.io/2016/09/25/kafka-spark-pipeline-part-1/
- https://github.com/divolte/divolte-spark

# jmxtrans other examples
https://github.com/jmxtrans/jmxtrans/wiki/MoreExamples
