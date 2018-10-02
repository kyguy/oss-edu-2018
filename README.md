# Logging + Strimzi Demo 

Prerequisites:
* OpenShift Instance with logging enabled
* Namespace "myproject"

## Cluster Operator

`oc apply -f 01-install-cluster-operator/`

## Basic Kafka cluster

`oc apply -f 02-simplest-cluster.yaml`

