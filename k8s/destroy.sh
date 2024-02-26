#!/bin/bash
kubectl delete -f 04_service.yaml --force
kubectl delete -f 03_deployment.yaml --force
kubectl delete -f 02_secret.yaml --force
kubectl delete -f 01_namespace.yaml --force
