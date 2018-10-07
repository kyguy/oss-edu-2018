#!/bin/bash
POD=logging-fluentd
PROJECT=openshift-logging
oc apply -f ./config/logging-cm.yaml -n $PROJECT
oc delete pod $(oc get pods -n $PROJECT | grep $POD | awk 'NR==1{print $1}') -n $PROJECT --grace-period=0
