#!/bin/bash
oc exec -ti $(oc get pods | grep 'my-cluster-kafka-0' | awk '{print $1}') -- ./bin/kafka-topics.sh --list --zookeeper localhost:2181
