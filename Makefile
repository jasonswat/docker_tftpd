default: help

include variables
include secrets

image_name="tftpd_server"
repo="jasonswat"

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[\/a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' Makefile

binary_check := $(foreach exec, docker, \
        $(if $(shell which $(exec)),"",$(error "No $(exec) in PATH")))

build: ## Build the docker image
	docker build --tag ${repo}/${image_name} \
		     --build-arg TIME_ZONE=${TIME_ZONE} \
		     --build-arg HTTP_SERVER=${HTTP_SERVER} \
		     --build-arg HOSTNAME=${HOSTNAME} \
		     --build-arg PARTMAN_GUIDED_SIZE=${PARTMAN_GUIDED_SIZE} \
		     --build-arg CLOUD_CONFIG=${CLOUD_CONFIG} \
		     --build-arg DEVICE=${DEVICE} \
				 --build-arg USERNAME=${USERNAME} \
				 --build-arg USER_PASSWORD=${USER_PASSWORD} \
				 --build-arg ROOT_PASSWORD=${ROOT_PASSWORD} \
				 --build-arg SSH_AUTHORIZED_KEY=${SSH_AUTHORIZED_KEY} . 

docker/run: ## Run the docker container
	docker run -d --rm \
		-p 8080:80 \
		-p 69:69/udp \
		-p 8082:8080 \
		-p 8081:8081 \
		-v "${PWD}/tls:/etc/matchbox" \
		--name tftpd_server \
		jasonswat/tftpd_server:latest

docker/runshell: docker/run bash ## Run the container and open a shell in the container

docker/stop: ## Stop and remove the docker image
	docker stop tftpd_server

docker/rmi: ## Stop and remove the docker image
	docker rmi jasonswat/tftpd_server:latest

.PHONY: build
