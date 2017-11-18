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
	@curl -L 'https://raw.githubusercontent.com/XD-DENG/Spark-practice/master/sample_data/2015-12-12.csv' > 2015-12-12.csv && \
	@echo "***********************************************" && \
	@echo "" && \
	@echo "Create Producer: " && \
	docker run \
		-d \
		-v ./2015-12-12.csv:/2015-12-12.csv \
		--net=host \
		--rm \
		confluentinc/cp-kafka:latest \
		kafka-console-producer --broker-list localhost:29092 --topic test < /2015-12-12.csv;
	@echo "" && \
	@echo "***********************************************"
