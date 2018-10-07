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

## Apply Logging configuration

Have logging aggregator forward all logs to Fluentd source connector

`./05-update-fluentd.sh`

## Activate Connectors

To start pushing and pulling data into Kafka

`./06-connectors.sh start`

## Once built

```
# Send Loggy through
./bin/gen-logs.sh loggy

# Observe
./query-es.sh _cat/indices

# Generate more logs
./bin/gen-logs.sh 100

```

## TODO
* Prometheus integration 

## Cleanup
```
./bin/connectors stop
oc delete kafkaconnects2i my-connect-cluster
oc delete kafka my-cluster
# Once those have finished
oc delete deployments,crds,svc --all
```
