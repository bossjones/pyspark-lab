SHELL := $(shell which bash)

export PATH := ./bin:./venv/bin:$(PATH)

YOUR_HOSTNAME := $(shell hostname | cut -d "." -f1 | awk '{print $1}')

export HOST_IP=$(shell curl ipv4.icanhazip.com 2>/dev/null)

username := bossjones
container_name := boss-pyspark-notebook

GIT_BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
GIT_SHA     = $(shell git rev-parse HEAD)
BUILD_DATE  = $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
VERSION  = latest

LOCAL_REPOSITORY = $(HOST_IP):5000

CURRENT_DIR := $(shell pwd)

BASE_DIR := $(shell basename "$(CURRENT_DIR)")

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

bash:
	docker run \
	-v $(BASE_DIR):/home/jovyan/work \
	--name=$(container_name)-bash \
	-e DOCKERHOST \
	-e HOST_IP \
	-e _YOUR_HOSTNAME \
	--rm \
	-it \
	$(username)/$(container_name):latest \
	bash

exec:
	docker exec \
	-it \
	$(container_name)-bash \
	bash

notebook:
	docker run -it \
	-v $(BASE_DIR):/home/jovyan/work \
	--name=$(container_name) \
	--rm \
	-p 8888:8888 \
	$(username)/$(container_name)

notebook-no-pass:
	docker run \
	-v $(BASE_DIR):/home/jovyan/work \
	--name=$(container_name) \
	-d -p 8888:8888 \
	$(username)/$(container_name) \
	start-notebook.sh \
	--NotebookApp.token=''

kill:
	docker kill $(container_name); \
	docker rm $(container_name)

ipython:
	docker run -it \
	-v $(BASE_DIR):/home/jovyan/work \
	--name=$(container_name) \
	--rm \
	$(username)/$(container_name) \
	start.sh \
	ipython
