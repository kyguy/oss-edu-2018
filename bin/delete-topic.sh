#!/bin/bash
TOPIC=($1)
oc exec -ti $(oc get pods | grep 'my-connect-cluster-connect' | awk 'NR==1{print $1}') -- curl -X DELETE http://localhost:8083/connectors/FluentdSinkConnector
echo ""
oc exec -ti $(oc get pods | grep 'my-connect-cluster-connect' | awk 'NR==1{print $1}') -- curl -X DELETE http://localhost:8083/connectors/FluentdSourceConnector
echo ""

oc exec -c kafka -ti $(oc get pods | grep 'my-cluster-kafka-0' | awk '{print $1}') -- ./bin/kafka-topics.sh --delete --zookeeper localhost:2181 --topic $TOPIC
