# Logging + Strimzi Demo 

Prerequisites:
* OpenShift Instance with logging enabled
* Namespace "myproject"

## Cluster Operator

`oc apply -f 01-install-cluster-operator/`

## Basic Kafka cluster

`oc apply -f 02-kafka-cluster.yaml`

## Deploy Kafka Connect

`oc apply -f 03-kafka-connect.yaml`

** Will be in error start until Kafka Connectors are loaded in the next step

## Load Kafka Connectors

Load pluggable Kafka Connectors ( specifically, Fluentd source and sink connectors) using S2I

`./04-load-connect-plugin.sh`

## Forward traffic to Fluentd Connector

Create service to link to Fluentd source connector

`oc apply -f 05-connector-svc.yaml`

## Apply Logging configuration

Have logging aggregator forward all logs to Fluentd source connector

`oc apply -f 06-logging-cm.yaml`

## Activate Connectors

To start pushing and pulling data into Kafka

`./07-connectors.sh start`

## TODO
* Prometheus integration 
