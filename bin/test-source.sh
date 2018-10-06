#!/bin/bash
CONNECT_POD=my-connect-cluster-connect
COMMAND=($1)
oc exec -ti $(oc get pods | grep $CONNECT_POD | awk '{print $1}') -- fluentd -c /opt/kafka/source-test.conf
#oc exec -ti $(oc get pods | grep $CONNECT_POD | awk '{print $1}') -- fluentd -c /tmp/kafka-plugins/s2i/kafka-connect-fluentd/source-test.conf
