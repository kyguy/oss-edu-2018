#!/bin/bash
oc exec -ti $(oc get pod -l app=my-connect-cluster-connect -o=jsonpath='{.items[0].metadata.name}') -- ./bin/kafka-topics.sh --list --zookeeper localhost:2181
