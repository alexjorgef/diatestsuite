mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
project_path := $(dir $(mkfile_path))
image_version = 0.1
image_name = dia-http-restserver
image_tag = $(image_name):$(image_version)
MINIKUBE ?= minikube
MINIKUBE_DOCKER_ENV ?= eval $$($(MINIKUBE) docker-env)
build:
	docker build -f $(project_path)/Dockerfile --tag=$(image_tag) .
load:
	docker save $(image_tag) | ($(MINIKUBE_DOCKER_ENV) && docker load)