#!/bin/bash
oc exec -ti $(oc get pod -l app=my-cluster-kafka-0 -o=jsonpath='{.items[0].metadata.name}') -- ./bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic output_tag --from-beginning
