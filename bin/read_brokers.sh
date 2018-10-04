#!/bin/bash
oc exec -ti $(oc get pods | grep 'my-cluster-kafka-0' | awk '{print $1}') -- ./bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic output_tag --from-beginning
