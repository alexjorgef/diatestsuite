#!/usr/bin/env bash
MINIKUBE_DASHBOARD_PORT=8083
minikube dashboard --url=true --port="${MINIKUBE_DASHBOARD_PORT}"