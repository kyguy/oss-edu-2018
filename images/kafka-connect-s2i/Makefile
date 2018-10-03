# Makefile.docker contains the shared tasks for building, tagging and pushing Docker images.
# This file is included into the Makefile files which contain the Dockerfile files
#
# The DOCKER_ORG (default is name of the current user) and DOCKER_TAG (based on Git Tag,
# default latest) variables are used to name the Docker image. DOCKER_REGISTRY identifies
# the registry where the image will be pushed (default is Docker Hub).
TOPDIR=$(dir $(lastword $(MAKEFILE_LIST)))
DOCKERFILE_DIR     ?= ./
DOCKER_REGISTRY    ?= docker.io
DOCKER_ORG         ?= kliberti#$(USER)
PROJECT_NAME       ?= kafka-connect-s2i
DOCKER_TAG         ?= latest
RELEASE_VERSION    ?= 0.7.0

all: docker_build docker_push

docker_build:
	# Build Docker image ...
	docker build -q $(DOCKER_BUILD_ARGS) --build-arg strimzi_version=$(RELEASE_VERSION) -t $(DOCKER_REGISTRY)/$(DOCKER_ORG)/$(PROJECT_NAME):latest $(DOCKERFILE_DIR)

docker_push: docker_build
	# Push the tagged image to the registry
	docker push $(DOCKER_REGISTRY)/$(DOCKER_ORG)/$(PROJECT_NAME):$(DOCKER_TAG)
