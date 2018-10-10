#!/bin/bash
CONNECT_POD=my-connect-cluster-connect
PROJECT=myproject
COMMAND=($1)
TOPIC=($2)

if [ -z "$TOPIC" ]; then
  TOPIC=output_tag
fi

exec_in_pod () {
  oc exec -ti $( oc get pods -n $PROJECT | grep $CONNECT_POD | awk 'NR==1{print $1}' ) -n $PROJECT -- "$@"
}

if [[ $COMMAND = "start" ]]; then
  echo "-----------------------------"
  echo "Starting source connector ..."
  echo "-----------------------------"
  exec_in_pod \
  curl -X POST -H "Content-Type: application/json" --data '
  { "name": "FluentdSourceConnector",
    "config": { 
      "connector.class":"org.fluentd.kafka.FluentdSourceConnector",
      "tasks.max":"3",
      "fluentd.port":"24224", 
      "fluentd.bind":"0.0.0.0", 
      "fluentd.worker.pool.size":"1", 
      "fluentd.counter.enabled":"true",
      "fluentd.schemas.enable":"false"
    }
  }' http://localhost:8083/connectors
  
  echo ""
  echo ""
  echo "-----------------------------"
  echo "Starting sink connector ..."
  echo "-----------------------------"
  exec_in_pod \
  curl -X POST -H "Content-Type: application/json" --data '
  { "name": "FluentdSinkConnector", 
    "config": {
      "connector.class":"org.fluentd.kafka.FluentdSinkConnector",
      "tasks.max":"3", 
      "fluentd.connect":"localhost:24225", 
      "fluentd.worker.pool.size":"1", 
      "fluentd.counter.enabled":"true",
      "fluentd.schemas.enable":"false", 
      "topics": "'"${TOPIC}"'"
    }
  }' http://localhost:8083/connectors
  echo ""
else
  echo "--------------------------------"
  echo "Terminating source connector ..."
  echo "--------------------------------"
  exec_in_pod \
  curl -X DELETE http://localhost:8083/connectors/FluentdSourceConnector
  echo ""
  echo "-------------------------------"
  echo "Terminating sink connector ..."
  echo "-------------------------------"
  exec_in_pod \
  curl -X DELETE http://localhost:8083/connectors/FluentdSinkConnector
  echo ""
  echo "Connectors left running: "
  exec_in_pod \
  curl -X GET http://localhost:8083/connectors
  echo ""
fi
