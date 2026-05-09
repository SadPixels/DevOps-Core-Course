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

The chart creates a Kubernetes `Deployment` with three replicas and exposes the application through a `NodePort` `Service`.

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

containerPort: 8080
```

The application listens on port `8080`, so the chart uses `8080` as the container port and service port.

## Build image for Minikube

Run these commands from the repository root:

```bash
minikube start --driver=docker
minikube image build -t moscow-time-app:1.0.0 ./app_python
```

The image tag used during build must be the same as the tag in `k8s/moscow-time-app/values.yaml`. The chart uses `pullPolicy: Never`, so Kubernetes expects this image to already exist inside Minikube.

## Install the chart

```bash
helm install moscow-time-app ./k8s/moscow-time-app
```

Expected output:

```text
NAME: moscow-time-app
LAST DEPLOYED: Sat May  9 18:32:07 2026
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The Moscow Time application has been installed.

Check resources:
  kubectl get pods,svc

Open the application with Minikube:
  minikube service moscow-time-app
```

## Check deployed resources

Wait until the deployment is ready:

```bash
kubectl rollout status deployment/moscow-time-app
```

Check pods and services:

```bash
kubectl get pods,svc
```

Output:

```text
NAME                                   READY   STATUS    RESTARTS   AGE
pod/moscow-time-app-7c9c8b8d8f-4kq2m   1/1     Running   0          35s
pod/moscow-time-app-7c9c8b8d8f-b9k6v   1/1     Running   0          35s
pod/moscow-time-app-7c9c8b8d8f-v2n8h   1/1     Running   0          35s

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/kubernetes        ClusterIP   10.96.0.1        <none>        443/TCP          12m
service/moscow-time-app   NodePort    10.110.120.181   <none>        8080:30080/TCP   35s
```

## Open the application

```bash
minikube service moscow-time-app
```

Output:

```text
|-----------|-----------------|-------------|---------------------------|
| NAMESPACE |      NAME       | TARGET PORT |            URL            |
|-----------|-----------------|-------------|---------------------------|
| default   | moscow-time-app | http/8080   | http://192.168.49.2:30080 |
|-----------|-----------------|-------------|---------------------------|
Opening service default/moscow-time-app in default browser...
```

Application URL:

```text
http://192.168.49.2:30080
```

## Reinstall

```bash
helm uninstall moscow-time-app
helm install moscow-time-app ./k8s/moscow-time-app
```

## Uninstall

```bash
helm uninstall moscow-time-app
```
