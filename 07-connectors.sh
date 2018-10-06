#!/bin/bash
CONNECT_POD=my-connect-cluster-connect
COMMAND=($1)
if [[ $COMMAND = "start" ]]; then
  echo "Starting source connector ..."
  oc exec -ti $(oc get pods | grep $CONNECT_POD | awk 'NR==1{print $1}') -- curl -X POST -H "Content-Type: application/json" --data '{"name": "FluentdSourceConnector", "config": {"connector.class":"org.fluentd.kafka.FluentdSourceConnector", "tasks.max":"3", "fluentd.connect":"localhost:24224", "fluentd.port":"24224", "fluentd.bind":"0.0.0.0", "fluentd.worker.pool.size":"2", "fluentd.counter.enabled":"true","fluentd.schemas.enable":"false"}}' http://localhost:8083/connectors
  echo ""
  echo ""
  echo "Starting sink connector ..."
  #oc exec -ti $(oc get pods | grep $CONNECT_POD | awk '{print $1}') -- curl -X POST -H "Content-Type: application/json" --data '{"name": "FluentdSinkConnector", "config": {"connector.class":"org.fluentd.kafka.FluentdSinkConnector", "tasks.max":"1", "fluentd.connect":"localhost:24225", "fluentd.port":"24225", "fluentd.bind":"0.0.0.0", "fluentd.worker.pool.size":"1", "fluentd.counter.enabled":"true","fluentd.schemas.enable":"false", "fluentd.client.wait.until.buffer.flushed":"0", "fluentd.client.wait.until.flusher.terminated":"0", "fluentd.client.flush.interval":"10","topics":"output_tag"}}' http://localhost:8083/connectors
  oc exec -ti $(oc get pods | grep $CONNECT_POD | awk 'NR==1{print $1}') -- curl -X POST -H "Content-Type: application/json" --data '{"name": "FluentdSinkConnector", "config": {"connector.class":"org.fluentd.kafka.FluentdSinkConnector", "tasks.max":"3", "fluentd.connect":"localhost:24225", "fluentd.port":"24225", "fluentd.bind":"0.0.0.0", "fluentd.worker.pool.size":"2", "fluentd.counter.enabled":"true","fluentd.schemas.enable":"false", "fluentd.client.wait.until.buffer.flushed":"1", "fluentd.client.wait.until.flusher.terminated":"1", "fluentd.client.flush.interval":"1","topics":"output_tag"}}' http://localhost:8083/connectors
  echo ""
  # "fluentd.client.wait.until.buffer.flushed":"0"
  # "fluentd.client.wait.until.flusher.terminated":"0"
  # "fluentd.client.flush.interval":"10" 
  #for sink? "fluentd.client.timestamp.integer":"true"
else
  echo "Terminating source connector ..."
  oc exec -ti $(oc get pods | grep $CONNECT_POD | awk 'NR==1{print $1}') -- curl -X DELETE http://localhost:8083/connectors/FluentdSourceConnector
  echo ""
  echo "Terminating sink connector ..."
  oc exec -ti $(oc get pods | grep $CONNECT_POD | awk 'NR==1{print $1}') -- curl -X DELETE http://localhost:8083/connectors/FluentdSinkConnector
  echo ""
  echo "Connectors left running: "
  oc exec -ti $(oc get pods | grep $CONNECT_POD | awk 'NR==1{print $1}') -- curl -X GET http://localhost:8083/connectors
  echo ""
fi
