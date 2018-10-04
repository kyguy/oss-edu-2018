#!/bin/bash
# Querys Elasticsearch instance
#
# Some query arguments for COMMAND:
#   _cat/indices
#   <index>/_search

PROJECT=openshift-logging
COMMAND=($1)
set -e

if [ -z "$COMMAND" ]
then
  oc exec -n $PROJECT -ti  $(oc get pods -n $PROJECT | grep 'logging-es' | awk '{print $1}') -- es_util --query='_cluster/health?pretty'
else
  oc exec -n $PROJECT -ti  $(oc get pods -n $PROJECT | grep 'logging-es' | awk '{print $1}') -- es_util --query=$COMMAND'?pretty'
fi
