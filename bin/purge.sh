!#/bin/bash
oc delete kafkaconnects2i my-connect-cluster
oc delete kafka my-cluster
# Once those have finished
oc delete deployments,svc --all
oc delete sa strimzi-cluster-operator
