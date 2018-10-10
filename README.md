# A day in the life of a log

Building a distributed data pipeline from Apache Kafka and OpenShift

Prerequisites:
* OpenShift Instance with logging enabled ( EFK stack )
* Namespace "myproject"

## Cluster Operator

The core component of strimzi which monitors custom resources, matching the state of the cluster with whats described in the custom resources. We will feed the cluster operator with custom resources describing our Kafka cluster and the cluster operator will build the Kafka cluster according to these specifications.

`oc apply -f 01-install-cluster-operator/`

## Basic Kafka cluster

Let deploys a bare bones Kafka cluster consisting of one Kafka node and one Zookeeper node. Here we describe a kafka custom resource and give it to the cluster operator who then creates the actual cluster based on our description. 

`oc apply -f 02-kafka-cluster.yaml`

## Deploy Kafka Connect

Next, for external components to communicate with Kafka, we want to deploy a Kafka Connect instance which can load pluggable Kafka connectors. Kafka Connect will allow us to interface other systems with Kafka whether they be filesystems, databases, or application servers. The framework manages how data is written and read from Kafka brokers.

`oc apply -f 03-kafka-connect.yaml`

** Will be in error start until Kafka Connectors are loaded in the next step

## Load Kafka Connectors

Next lets load pluggable Kafka Connectors into our Kafka Connect Instance. These connectors describe how data is broken up from external systems (Source) and how data is divided for external systems(Sink). Kafka Connect handles the writting of broken up data into the Kafka brokers and the reading of data from the Kafka brokers. 

`./04-load-connect-plugin.sh`
 
## Activate Connectors
Our Kafka Connect instances has an REST interface which we can use to activate our connectors. Lets activate our Kafka connectors, a source connector to foward data from external systems to our Kafka brokers and a sink connector toand to read data from our Kafka brokers and forward it to our external systems

`./05-connectors.sh start`

## Apply Logging configuration

Lets then update the aggregated logger to forward all the log traffic to our Kafka cluster, specifically, our sink connector

`./06-update-fluentd.sh`

## Once built

```
#----------------------
# Loggy's Commute
#----------------------
# Send Loggy through
./bin/gen-logs.sh loggy

# Loggy in aggregator
./bin/aggregate_logger.sh loggy | grep :D

# Loggy in the broker
./bin/read_brokers.sh | grep :D

# ElasticSearch Indices
./bin/elasticsearch

# Loggy in ElasticSearch
./bin/elasticsearch loggy | grep :D 

#-----------------------
# Loggy's neighbors
#-----------------------
# Generate more logs
./bin/gen-logs.sh 100

# Loggy's neighbors
./bin/read_brokers.sh output_tag | grep :\)

# Loggy's 100 neighbors represented in the indices
./bin/elasticsearch

# Loggy in ElasticSearch
./bin/elasticsearch loggy | grep :\) 
```

## TODO
* Prometheus integration 
* Graphana integration

## Cleanup

` ./bin/purge `
