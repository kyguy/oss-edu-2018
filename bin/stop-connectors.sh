#!/bin/bash
oc exec -ti $(oc get pod -l app=my-connect-cluster-connect -o=jsonpath='{.items[0].metadata.name}') -- curl -X DELETE http://localhost:8083/connectors/FluentdSinkConnector
oc exec -ti $(oc get pod -l app=my-connect-cluster-connect -o=jsonpath='{.items[0].metadata.name}') -- curl -X DELETE http://localhost:8083/connectors/FluentdSourceConnector
