#!/bin/bash
POD=logging-fluentd
PROJECT=openshift-logging
CONFIG=./config/logging-cm.yaml
oc apply -f $CONFIG -n $PROJECT
oc delete pod $(
                oc get pods -n $PROJECT | 
		grep $POD | 
		awk 'NR==1{print $1}'\
	       ) -n $PROJECT --grace-period=0
