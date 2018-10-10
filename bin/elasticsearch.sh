#!/bin/bash
# Querys Elasticsearch instance
#
# Some query arguments for COMMAND:
#   _cat/indices
#   <index>/_search
PROJECT=openshift-logging
POD=logging-es
CONTAINER=elasticsearch
COMMAND=($1)
set -e
set -o xtrace

exec_in_pod () {
  oc exec -c $CONTAINER -ti $(\
                 oc get pods -n $PROJECT |
                 grep $POD |
                 awk 'NR==1{print $1}'\
               ) -n $PROJECT -- "$@"
}

if [ -z "$COMMAND" ]
then
  exec_in_pod \
    es_util --query='_cat/indices?pretty'
else
  if [[ $COMMAND = "loggy" ]]; then
   index=$(exec_in_pod es_util --query='_cat/indices?pretty' | grep project.instrumented-app |  awk '{print $3}')
   echo $index
   exec_in_pod \
     es_util --query=$index'/_search?pretty'
  else
    echo $COMMAND
    exec_in_pod \
      es_util --query=$COMMAND'?pretty'
  fi
fi
