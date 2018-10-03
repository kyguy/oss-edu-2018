PROJECT_NAME       ?= formatted-logs
BUILD_DATE         := $(shell date -u +%Y-%m-%dT%H-%M-%SZ)
COMMIT_ID          := $(shell git log --pretty=format:'%h' -n 1)
GO_FLAGS           := -ldflags "-w -X main.buildDate=$(BUILD_DATE) -X main.commitId=$(COMMIT_ID)"

all: buildstatic

build:
	go build $(GO_FLAGS) .

buildstatic:
	go build $(GO_FLAGS) -tags netgo .

include ../../Makefile.docker
