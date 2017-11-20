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
