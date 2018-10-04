#!/bin/bash
oc exec -ti $(oc get pods | grep 'my-connect-cluster-connect' | awk '{print $1}') -- curl -X DELETE http://localhost:8083/connectors/FluentdSinkConnector
oc exec -ti $(oc get pods | grep 'my-connect-cluster-connect' | awk '{print $1}') -- curl -X DELETE http://localhost:8083/connectors/FluentdSourceConnector
oc exec -ti $(oc get pods | grep 'my-cluster-kafka-0' | awk '{print $1}') -- ./bin/kafka-topics.sh --delete --zookeeper localhost:2181 --topic output_tag
