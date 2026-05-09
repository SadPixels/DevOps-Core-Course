# Helm deployment

This document describes how to deploy the Moscow Time Flask application to a local Minikube cluster with Helm.

## Application

Application source code:

```text
app_python/
```

Helm chart:

```text
k8s/moscow-time-app/
```

The chart creates a Kubernetes `StatefulSet`, a NodePort Service, a headless Service, an Opaque Secret, persistent volume claims for visit counters, and CPU/memory requests and limits.

## Chart values

Main values are defined in `k8s/moscow-time-app/values.yaml`:

```yaml
replicaCount: 3

image:
  repository: moscow-time-app
  tag: 1.0.0
  pullPolicy: Never

service:
  type: NodePort
  port: 8080
  nodePort: 30080

persistence:
  mountPath: /data
  visitsFile: /data/visits
  size: 1Gi

statefulset:
  podManagementPolicy: Parallel
```

The application listens on port `8080`. The visit counter is written to `/data/visits`, which is mounted from a per-pod PVC.

## Build image for Minikube

Run these commands from the repository root:

```bash
minikube start --driver=docker
minikube image build -t moscow-time-app:1.0.0 ./app_python
```

The image tag used during build must be the same as the tag in `k8s/moscow-time-app/values.yaml`. The chart uses `pullPolicy: Never`, so Kubernetes expects this image to already exist inside Minikube.

## Install the chart

```bash
helm upgrade --install moscow-time-app ./k8s/moscow-time-app
```

## Check deployed resources

```bash
kubectl rollout status statefulset/moscow-time-app
kubectl get po,sts,svc,pvc
```

## Open the application

```bash
minikube service moscow-time-app
```

## Check persisted visits

```bash
kubectl exec pod/moscow-time-app-0 -- cat /data/visits
kubectl exec pod/moscow-time-app-1 -- cat /data/visits
kubectl exec pod/moscow-time-app-2 -- cat /data/visits
```

## Check StatefulSet DNS

```bash
kubectl exec pod/moscow-time-app-0 -- nslookup moscow-time-app-1.moscow-time-app-headless
```

## Uninstall

```bash
helm uninstall moscow-time-app
kubectl delete pvc -l app.kubernetes.io/name=moscow-time-app
```
