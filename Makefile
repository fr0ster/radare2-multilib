SHELL := /bin/bash

# The directory of this file
DIR := $(shell echo $(shell cd "$(shell  dirname "${BASH_SOURCE[0]}" )" && pwd ))


# To mount a specific binary using BINARY=/absolute/path/to/binary
ifdef BINARY
    MOUNTFLAGS += -v $(BINARY):/home/r2/$(shell basename $(BINARY)):ro
    RUNFLAGS += /home/r2/$(shell basename $(BINARY))
endif

VERSION ?= latest
IMAGE_NAME ?= luckycatalex/radare2

LOCAL_DEV ?= n

# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

multilib-image: ## Build the base image
	sudo docker build --network=host -t $(IMAGE_NAME)-multilib:$(VERSION) -f Dockerfile .

multilib-image-nc: ## Build the base image without caching
	sudo docker build --network=host --no-cache -t $(IMAGE_NAME)-multilib:$(VERSION) -f Dockerfile .

base-image: ## Build the base image
	sudo docker build --network=host -t $(IMAGE_NAME)-base:$(VERSION) -f Dockerfile.base .

base-image-nc: ## Build the base image without caching
	sudo docker build --network=host --no-cache -t $(IMAGE_NAME)-base:$(VERSION) -f Dockerfile.base .

r2ghidra-image: ## Build the base image
	sudo docker build --network=host -t $(IMAGE_NAME)-r2ghidra:$(VERSION) -f Dockerfile.r2ghidra .

r2ghidra-image-nc: ## Build the base image without caching
	sudo docker build --network=host --no-cache -t $(IMAGE_NAME)-r2ghidra:$(VERSION) -f Dockerfile.r2ghidra .
