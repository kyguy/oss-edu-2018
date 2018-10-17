#!/bin/bash
TOPIC=($1)
POD=my-connect-cluster-connect

if [ -z $TOPIC ]; then
  TOPIC=output_tag
fi

oc exec -ti $(oc get pods | grep $POD | awk 'NR==1{print $1}') -- ./bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic $TOPIC --from-beginning
