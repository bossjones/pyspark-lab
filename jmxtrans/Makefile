SHELL := $(shell which bash)

# export DOCKER_IP = $(shell which docker-machine > /dev/null 2>&1 && docker-machine ip $(DOCKER_MACHINE_NAME))

export PATH := ./bin:./venv/bin:$(PATH)

YOUR_HOSTNAME := $(shell hostname | cut -d "." -f1 | awk '{print $1}')

export HOST_IP=$(shell curl ipv4.icanhazip.com 2>/dev/null)

username := bossjones
container_name := boss-jmxtrans

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

run-dm-jmxtrans-kafka-d:
	docker run \
	-it \
	--rm \
	-d \
	--name=jmxtrans-kafka \
	--net="host" \
	-e JMX_HOST=$(HOST_IP) \
	-e JMX_PORT="49999" \
	-e STATSD_HOST=$(HOST_IP) \
	-e STATSD_PORT="8125" \
	bossjones/boss-jmxtrans:latest

run-dm-jmxtrans-zk-d:
	docker run \
	-it \
	--rm \
	-d \
	--name=jmxtrans-zk \
	--net="host" \
	-e JMX_HOST=$(HOST_IP) \
	-e JMX_PORT="39999" \
	-e STATSD_HOST=$(HOST_IP) \
	-e STATSD_PORT="8125" \
	bossjones/boss-jmxtrans:latest

kill:
	docker kill jmxtrans-zk
	docker kill jmxtrans-kafka

run-dm-jmxtrans-kafka:
	docker run \
	-it \
	--rm \
	--name=jmxtrans \
	--net="host" \
	-e JMX_HOST=$(shell docker-machine ip dev) \
	-e JMX_PORT="49999" \
	-e STATSD_HOST=$(shell docker-machine ip dev) \
	-e STATSD_PORT="8125" \
	bossjones/boss-jmxtrans:latest

# run-dm-jmxtrans-zk:
# 	docker run \
# 	-it \
# 	--rm \
# 	--name=jmxtrans \
# 	--net="host" \
# 	-e JMX_HOST=$(shell docker-machine ip dev) \
# 	-e JMX_PORT="39999" \
# 	-e STATSD_HOST=$(shell docker-machine ip dev) \
# 	-e STATSD_PORT="8125" \
# 	bossjones/boss-jmxtrans:latest

run-dm-jmxtrans-zk:
	docker run \
	-it \
	--rm \
	--name=jmxtrans \
	-e JMX_HOST=$(shell docker-machine ip dev) \
	-e JMX_PORT="39999" \
	-e STATSD_HOST=$(shell docker-machine ip dev) \
	-e STATSD_PORT="8125" \
	bossjones/boss-jmxtrans:latest


# run-jmxtrans-docker-machine-jmx: run-jmxtrans-dm-jmx

force-rm:
	docker rm jmxtrans-jmx; \
	docker rmi jmxtrans-jmx
