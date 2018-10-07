#!/bin/bash
POD=formatted-logs
PROJECT=instrumented-app
ARG=($1)
if [[ $ARG = "loggy" ]]; then
  oc exec -n $PROJECT -ti $(oc get pods -n $PROJECT | grep $POD | awk '{print $1}') -- curl http://localhost:8080/loggy
else
  oc exec -n $PROJECT -ti $(oc get pods -n $PROJECT | grep $POD | awk '{print $1}') -- curl http://localhost:8080/generate?logs=$ARG
fi
