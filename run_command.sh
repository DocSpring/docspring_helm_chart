#!/bin/bash
WEB_POD_ID="$(kubectl get pod -l app=docspring-enterprise,component=web -o jsonpath='{.items[0].metadata.name}')"
echo "Running command in $WEB_POD_ID:" "$@"

kubectl exec -it "$WEB_POD_ID" -- "$@"
