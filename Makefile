SHELL := /bin/bash

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

run-multilib: ## Run container from mulilib image
	sudo docker run --network=host --rm -it $(IMAGE_NAME)-multilib:$(VERSION) bash

run-ghidra: ## Run container from r2ghidra image
	sudo docker run --network=host --rm -it $(IMAGE_NAME)-r2ghidra:$(VERSION) bash

get-multilib: ## Get the latest Iaito image
        sudo docker pull $(IMAGE_NAME)-multilib:$(VERSION)

get-base: ## Get the latest radare2 base image
        sudo docker pull $(IMAGE_NAME)-base:$(VERSION)

get-ghidra: ## Get the latest r2ghidra image
        sudo docker pull $(IMAGE_NAME)-r2ghidra:$(VERSION)

