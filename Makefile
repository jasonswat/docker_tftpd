default: help

image_name="tftpd_server"
repo="jasonswat"
http_server="http://192.168.10.184/MyWeb/software"
interface="eth0"

help: ## this help
	@awk 'BEGIN {FS = ":.*?## "} /^[\/a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' Makefile

binary_check := $(foreach exec, docker, \
        $(if $(shell which $(exec)),"",$(error "No $(exec) in PATH")))

build: ## build 
	docker build --tag "${repo}/${image_name}" --build-arg HTTP_SERVER="${http_server}" --build-arg INTERFACE=${interface} . 

.PHONY: build
