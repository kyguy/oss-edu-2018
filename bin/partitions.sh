#!/bin/bash
TOPIC=($1)
oc exec -c kafka -ti $(oc get pods | grep 'my-cluster-kafka-0' | awk '{print $1}') -- ./bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic $TOPIC
