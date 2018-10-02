# Logging + Strimzi Demo 

Prerequisites:
* OpenShift Instance with logging enabled
* Namespace "myproject"

## Cluster Operator

`oc apply -f 01-install-cluster-operator/`

## Basic Kafka cluster

`oc apply -f 02-simplest-cluster.yaml`

## Kafka Connect S2I

`oc start-build my-connect-cluster-connect --from-dir ./plugins/`

## TODO
* Test aggregator -> Kafka Connect thru service
* 
