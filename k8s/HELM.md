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

The chart creates a Kubernetes `Deployment` with three replicas, creates an `Opaque` Secret, sets CPU and memory requests/limits, and exposes the application through a `NodePort` Service.

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

secret:
  enabled: true
  passwordKey: MY_PASS
  password: "moscow-time-secret"

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 256Mi
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
helm upgrade --install moscow-time-app ./k8s/moscow-time-app
```

Expected output:

```text
Release "moscow-time-app" does not exist. Installing it now.
NAME: moscow-time-app
LAST DEPLOYED: Sat May  9 20:04:31 2026
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
pod/moscow-time-app-5f7b7dfd9b-2gpnd   1/1     Running   0          35s
pod/moscow-time-app-5f7b7dfd9b-7k9mt   1/1     Running   0          35s
pod/moscow-time-app-5f7b7dfd9b-zx4pc   1/1     Running   0          35s

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/kubernetes        ClusterIP   10.96.0.1        <none>        443/TCP          12m
service/moscow-time-app   NodePort    10.110.120.181   <none>        8080:30080/TCP   35s
```

## Check the Secret

```bash
kubectl get secret moscow-time-app-secret
kubectl exec moscow-time-app-5f7b7dfd9b-2gpnd -- printenv | grep MY_PASS
```

Output:

```text
NAME                     TYPE     DATA   AGE
moscow-time-app-secret   Opaque   1      35s
MY_PASS=moscow-time-secret
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
helm upgrade --install moscow-time-app ./k8s/moscow-time-app
```

## Uninstall

```bash
helm uninstall moscow-time-app
```
