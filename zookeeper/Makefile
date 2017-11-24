SHELL := $(shell which bash)

# export DOCKER_IP = $(shell which docker-machine > /dev/null 2>&1 && docker-machine ip $(DOCKER_MACHINE_NAME))

export PATH := ./bin:./venv/bin:$(PATH)

YOUR_HOSTNAME := $(shell hostname | cut -d "." -f1 | awk '{print $1}')

export HOST_IP=$(shell curl ipv4.icanhazip.com 2>/dev/null)

username := bossjones
container_name := boss-zookeeper

GIT_BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
GIT_SHA     = $(shell git rev-parse HEAD)
BUILD_DATE  = $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
VERSION  = latest

LOCAL_REPOSITORY = $(HOST_IP):5000

TAG ?= $(VERSION)
ifeq ($(TAG),@branch)
	override TAG = $(shell git symbolic-ref --short HEAD)
	@echo $(value TAG)
endif

list:
	@$(MAKE) -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort

build:
	docker build --tag $(username)/$(container_name):$(GIT_SHA) . ; \
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):latest
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):$(TAG)

build-force:
	docker build --rm --force-rm --pull --no-cache -t $(username)/$(container_name):$(GIT_SHA) . ; \
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):latest
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):$(TAG)

build-local:
	docker build --tag $(username)/$(container_name):$(GIT_SHA) . ; \
	docker tag $(username)/$(container_name):$(GIT_SHA) $(LOCAL_REPOSITORY)/$(username)/$(container_name):latest

tag-local:
	docker tag $(username)/$(container_name):$(GIT_SHA) $(LOCAL_REPOSITORY)/$(username)/$(container_name):$(TAG)
	docker tag $(username)/$(container_name):$(GIT_SHA) $(LOCAL_REPOSITORY)/$(username)/$(container_name):latest

push-local:
	docker push $(LOCAL_REPOSITORY)/$(username)/$(container_name):$(TAG)
	docker push $(LOCAL_REPOSITORY)/$(username)/$(container_name):latest

build-push-local: build-local tag-local push-local

tag:
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):latest
	docker tag $(username)/$(container_name):$(GIT_SHA) $(username)/$(container_name):$(TAG)

build-push: build tag
	docker push $(username)/$(container_name):latest
	docker push $(username)/$(container_name):$(GIT_SHA)
	docker push $(username)/$(container_name):$(TAG)

push:
	docker push $(username)/$(container_name):latest
	docker push $(username)/$(container_name):$(GIT_SHA)
	docker push $(username)/$(container_name):$(TAG)

push-force: build-force push

run-zk-jmx:
	docker run \
	-it \
	--rm \
	--name=zk-jmx \
	--net="host" \
	-e ZOOKEEPER_SERVER_ID="1" \
	-e ZOOKEEPER_TICK_TIME="2000" \
	-e ZOOKEEPER_CLIENT_PORT="32181" \
	-e KAFKA_JMX_PORT="39999" \
	-e KAFKA_JMX_HOSTNAME=$(HOST_IP) \
	bossjones/boss-zookeeper:latest

# run jmx though docker-machine
# KAFKA_JMX_HOSTNAME=docker-machine ip
# JMX connect to $KAFKA_JMX_HOSTNAME:39999
run-zk-dm-jmx:
	docker run \
	-it \
	--rm \
	--name=zk-jmx \
	--net="host" \
	-e ZOOKEEPER_SERVER_ID="1" \
	-e ZOOKEEPER_TICK_TIME="2000" \
	-e ZOOKEEPER_CLIENT_PORT="32181" \
	-e KAFKA_JMX_PORT="39999" \
	-e KAFKA_JMX_HOSTNAME=$(shell docker-machine ip dev) \
	bossjones/boss-zookeeper:latest

run-zk-docker-machine-jmx: run-zk-dm-jmx

force-rm:
	docker rm zk-jmx; \
	docker rmi zk-jmx
