#!/bin/bash
oc apply -f examples/kafka-connect/kafka-connect-s2i.yaml
oc start-build my-connect-cluster-connect --from-dir ./plugins/
