#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Stream tweets via Twitter API tracking keywords."""
from __future__ import print_function

# source: https://github.com/ksindi/kafka-pyspark-demo/blob/master/jobs/process.py
# from pyspark import Row
# from pyspark.conf import SparkConf
# from pyspark.sql import SparkSession
# from pyspark.streaming import StreamingContext
# from pyspark.streaming.kafka import KafkaUtils, TopicAndPartition

import os
from confluent_kafka import Producer
from pyspark.sql import SparkSession
from pyspark.sql.functions import explode
from pyspark.sql.functions import split

KAFKA_CONF = {'bootstrap.servers': 'localhost:29092'}
TOPIC = 'wordcount'
LIMIT = 100
PATH = ""

def main():
    word_producer = WordProducer(PATH)
    word_producer.produce_data()


class WordProducer(object):
    def __init__(self, path):
        super(WordProducer, self).__init__()
        self.path = path
        self.producer = Producer(**KAFKA_CONF)
        self.count = 0
        self.words = []

    def produce_data(self):
        with open(self.path, 'rt') as txt:
            for line in txt:
                if self.count <= LIMIT:
                    data = line.readline().strip()
                    self.producer.produce('wordcount', data.encode('utf-8'))
                    self.producer.flush()
                    self.count += + 1
                    self.words.append(data.encode('utf-8'))
                else:
                    print('FINISHED IMPORTING 100 WORDS!')
                    print(self.words)

    # def on_data(self, data):
    #     self.producer.produce(TOPIC, data.encode('utf-8'))
    #     self.producer.flush()
    #     print('Word count: ', self.count)
    #     self.count += + 1
    #     return self.count <= LIMIT

    # def on_error(self, status_code):
    #     if status_code == 420:  # rate limit
    #         return False


if __name__ == '__main__':
    main()
