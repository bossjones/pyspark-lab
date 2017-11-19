kafka-create-topic-twitter:
# create twitter Kafka topic if none exist
	docker run \
	--net=host \
	--rm confluentinc/cp-kafka:latest \
	kafka-topics --create --topic twitter --partitions 1 --replication-factor 1 \
		--if-not-exists --zookeeper localhost:32181

	docker run \
	--net=host \
	--rm confluentinc/cp-kafka:latest \
	kafka-topics --describe --topic twitter --zookeeper localhost:32181

	docker run \
	--net=host \
	--rm \
	confluentinc/cp-kafka:latest \
	kafka-console-consumer --bootstrap-server localhost:29092 --topic twitter \
		--new-consumer --from-beginning --max-messages 42

kafka-create-topic-test:
# Create a topic
	@echo "***********************************************"
	@echo ""
	@echo "Create Topic: "
	docker run \
		--net=host \
		--rm confluentinc/cp-kafka:latest \
		kafka-topics --create \
		--if-not-exists \
		--zookeeper localhost:32181 \
		--replication-factor 1 \
		--partitions 1 \
		--topic test
	@echo ""
	@echo "***********************************************"

# Verify that the topic is created successfully
	docker run
	--net=host \
	--rm \
	confluentinc/cp-kafka:latest \
	kafka-topics \
	--describe \
	--topic test \
	--zookeeper localhost:32181

# List all topics
	@echo "***********************************************"
	@echo ""
	@echo "List Topics: "
	docker run \
		--net=host \
		--rm confluentinc/cp-kafka:latest \
		kafka-topics --list \
		--zookeeper localhost:32181
	@echo ""
	@echo "***********************************************"

# Start producer
# Generate Data
	mkdir -p data && \
	curl -L -q 'https://raw.githubusercontent.com/XD-DENG/Spark-practice/master/sample_data/2015-12-12.csv' > ./data/2015-12-12.csv && \
	echo "***********************************************" && \
	echo "" && \
	echo "Create Producer: " && \
	docker run \
		-d \
		-it \
		-v ./data:/data \
		--net=host \
		--rm \
		confluentinc/cp-kafka:latest \
		bash -c "kafka-console-producer --broker-list localhost:29092 --topic test < /data/2015-12-12.csv";
	echo "" && \
	echo "***********************************************"

kafka-create-consumer:
# Read back the message using the Console consumer
	docker run \
	--net=host \
	-it \
	--rm \
	confluentinc/cp-kafka:latest \
	kafka-console-consumer \
	--bootstrap-server localhost:29092 \
	--topic test \
	--new-consumer \
	--from-beginning \
	--max-messages 42

dc-up:
	docker-compose -f docker-compose.zk-kafka.yml create && \
	docker-compose -f docker-compose.zk-kafka.yml start

dc-down:
	docker-compose -f docker-compose.zk-kafka.yml stop && \
	docker-compose -f docker-compose.zk-kafka.yml down

kafka-restart: kafka-down kafka-up

zk-up:
	docker-compose -f docker-compose.zk-kafka.yml up -d zookeeper

zk-down:
	docker-compose -f docker-compose.zk-kafka.yml down zookeeper

kafka-up:
	docker-compose -f docker-compose.zk-kafka.yml up -d kafka

kafka-down:
	docker-compose -f docker-compose.zk-kafka.yml down kafka
