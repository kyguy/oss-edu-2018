#!/bin/bash
PROJECT=openshift-logging
POD=logging-fluentd
COMMAND=($1)
set -e

exec_in_pod () {
  oc exec -ti $( oc get pods -n $PROJECT | grep $POD | awk 'NR==1{print $1}' ) -n $PROJECT -- "$@"
}

if [ -z "$COMMAND" ]; then
  exec_in_pod \
    ls /var/log/containers
else
  if [[ $COMMAND = "loggy" ]]; then
    exec_in_pod tail -f /var/log/containers/formatted-logs*
  else	  
    exec_in_pod \
      "$@"
  fi
fi
