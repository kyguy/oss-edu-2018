#!/bin/bash
POD=formatted-logs
PROJECT=instrumented-app

oc exec -n $PROJECT -ti $(oc get pods -n $PROJECT | grep $POD | awk '{print $1}') -- curl http://localhost:8080/generate?logs=10
echo ""
