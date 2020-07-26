default: help

include variables
include secrets

image_name="tftpd_server"
repo="jasonswat"
version=0.0.1

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[\/a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' Makefile

binary_check := $(foreach exec, docker, \
        $(if $(shell which $(exec)),"",$(error "No $(exec) in PATH")))

terraform/plan:  ## run terraform plan
	env && \
	cd terraform && \
	terraform plan

terraform/apply: ## run terraform apply
	cd terraform && \
	terraform apply	
	
build: ## Build the docker image
	docker build --tag ${repo}/${image_name}:${version} \
		    --build-arg TIME_ZONE=${TIME_ZONE} \
		    --build-arg HTTP_SERVER=${HTTP_SERVER} \
		    --build-arg HOSTNAME=${HOSTNAME} \
		    --build-arg PARTMAN_GUIDED_SIZE=${PARTMAN_GUIDED_SIZE} \
		    --build-arg CLOUD_CONFIG=${CLOUD_CONFIG} \
		    --build-arg DEVICE=${DEVICE} \
				--build-arg USERNAME=${USERNAME} \
				--build-arg USER_PASSWORD=${USER_PASSWORD} \
				--build-arg ROOT_PASSWORD=${ROOT_PASSWORD} \
				--build-arg SSH_AUTHORIZED_KEY=${TF_VAR_ssh_authorized_key} . 

matchbox/gen_certs: ## Generate selfsigned certs for matchbox gRCP
	docker run --rm \
		--name openssl \
		-w /tls \
		-e SAN="DNS.1:core,IP.1:192.168.10.150" \
		-e MATCHBOX_ASSETS_PATH="/tftpboot/coreos/" \
		-v "${PWD}/tls":/tls \
		--entrypoint "/tls/start_cert-gen.sh" \
		frapsoft/openssl

tftp_server/run: ## Run the docker container
	docker run -d --rm \
		-p 8080:80 \
		-p 69:69/udp \
		-p 8082:8080 \
		-p 8081:8081 \
		-e MATCHBOX_RPC_ADDRESS="0.0.0.0:8081" \
		-v "${PWD}/tls":/etc/matchbox \
		--name tftpd_server \
		jasonswat/tftpd_server:${version}

tftp_server/stop: ## Stop and remove the docker image
	docker stop tftpd_server

tftp_server/rmi: ## Stop and remove the docker image
	docker rmi jasonswat/tftpd_server:latest

.PHONY: build
