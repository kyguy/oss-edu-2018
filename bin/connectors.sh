#!/bin/bash
CONNECT_POD=my-connect-cluster-connect
COMMAND=($1)
if [[ $COMMAND = "start" ]]; then
  oc exec -ti $(oc get pods | grep $CONNECT_POD | awk '{print $1}') -- curl -X POST -H "Content-Type: application/json" --data '{"name": "FluentdSourceConnector", "config": {"connector.class":"org.fluentd.kafka.FluentdSourceConnector", "tasks.max":"1", "fluentd.connect":"localhost:24224", "fluentd.port":"24224", "fluentd.bind":"0.0.0.0", "fluentd.worker.pool.size":"1", "fluentd.counter.enabled":"true","fluentd.schemas.enable":"false"}}' http://localhost:8083/connectors

  oc exec -ti $(oc get pods | grep $CONNECT_POD | awk '{print $1}') -- curl -X POST -H "Content-Type: application/json" --data '{"name": "FluentdSinkConnector", "config": {"connector.class":"org.fluentd.kafka.FluentdSinkConnector", "tasks.max":"1", "fluentd.connect":"localhost:24225", "fluentd.port":"24225", "fluentd.bind":"0.0.0.0", "fluentd.worker.pool.size":"1", "fluentd.counter.enabled":"true","fluentd.schemas.enable":"false", "topics":"output_tag"}}' http://localhost:8083/connectors
else
  oc exec -ti $(oc get pods | grep $CONNECT_POD | awk '{print $1}') -- curl -X DELETE http://localhost:8083/connectors/FluentdSourceConnector
  oc exec -ti $(oc get pods | grep $CONNECT_POD | awk '{print $1}') -- curl -X DELETE http://localhost:8083/connectors/FluentdSinkConnector
  echo "Connectors running: "
  oc exec -ti $(oc get pods | grep $CONNECT_POD | awk '{print $1}') -- curl -X GET http://localhost:8083/connectors
  echo ""
fi
