VERSION ?= 5.9.8
IMAGE_NAME ?= luckycatalex/radare2

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

ghidra-image: ## Build the r2ghidra image
	sudo docker build --network=host -t $(IMAGE_NAME)-r2ghidra:$(VERSION) -f Dockerfile.r2ghidra .

ghidra-image-nc: ## Build the r2ghidra image without caching
	sudo docker build --network=host --no-cache -t $(IMAGE_NAME)-r2ghidra:$(VERSION) -f Dockerfile.r2ghidra .

ctf-image: ## Build the CTF image
	sudo docker build --network=host -t $(IMAGE_NAME)-ctf:$(VERSION) -f Dockerfile.ctf .

ctf-image-nc: ## Build the CTF image without caching
	sudo docker build --network=host --no-cache -t $(IMAGE_NAME)-ctf:$(VERSION) -f Dockerfile.ctf .

run-multilib: ## Run container from mulilib image
	sudo docker run --network=host --rm -it $(IMAGE_NAME)-multilib:$(VERSION) bash

run-base: ## Run container from base image
	sudo docker run --network=host --rm -it $(IMAGE_NAME)-base:$(VERSION) bash

run-ghidra: ## Run container from r2ghidra image
	sudo docker run --network=host --rm -it $(IMAGE_NAME)-r2ghidra:$(VERSION) bash

run-ctf: ## Run container from CTF image
	sudo docker run --network=host --rm -it $(IMAGE_NAME)-ctf:$(VERSION) bash

get-multilib: ## Get the latest multilib image
	sudo docker pull $(IMAGE_NAME)-multilib:$(VERSION)

get-base: ## Get the latest radare2 base image
	sudo docker pull $(IMAGE_NAME)-base:$(VERSION)

get-ghidra: ## Get the latest r2ghidra image
	sudo docker pull $(IMAGE_NAME)-r2ghidra:$(VERSION)

get-ctf: ## Get the latest CTF image
	sudo docker pull $(IMAGE_NAME)-ctf:$(VERSION)

