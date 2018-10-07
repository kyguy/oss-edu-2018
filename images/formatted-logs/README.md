# formatted-logs
Credit: Josef Karasek ( https://github.com/josefkarasek/formatted-logs )

HTTP server which generates logs based on requests

Prerequisites:
* golang
* GOPATH

## build

```
go get github.com/sirupsen/logrus
make
```

## run

`oc new-app --docker-image=<DOCKER_REGISTRY>/<DOCKER_ORG>/formatted-logs:latest`

## Generate logs

From within the pod, run:

### Loggy
`curl http://localhost:8080/loggy`

### Loggy Neighbors
`curl http://localhost:8080/generate?logs=100`



