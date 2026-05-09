# Kubernetes deployment

## Application

The repository contains a Flask Moscow Time application in `app_python/`.

Before applying Kubernetes manifests directly, build the image inside Minikube:

```bash
minikube start --driver=docker
minikube image build -t moscow-time-app:1.0.0 ./app_python
```

## Imperative deployment

Create a deployment:

```bash
kubectl create deployment moscow-time-app --image=moscow-time-app:1.0.0 --port=8080
```

Expose the deployment:

```bash
kubectl expose deployment moscow-time-app --type=NodePort --port=8080 --target-port=8080
```

Check resources:

```bash
kubectl get pods,svc
```

Output:

```text
NAME                                  READY   STATUS    RESTARTS   AGE
pod/moscow-time-app-b6fc54d88-nrfbc   1/1     Running   0          14s

NAME                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
service/kubernetes        ClusterIP   10.96.0.1      <none>        443/TCP          71m
service/moscow-time-app   NodePort    10.97.84.223   <none>        8080:31103/TCP   7s
```

Remove resources:

```bash
kubectl delete service moscow-time-app
kubectl delete deployment moscow-time-app
```

## Declarative manifests

Manifest files:

```text
k8s/deployment.yml
k8s/service.yml
```

Apply manifests:

```bash
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service.yml
```

Output:

```text
deployment.apps/moscow-time-app created
service/moscow-time-app created
```

Check resources:

```bash
kubectl get pods,svc
```

Output:

```text
NAME                                   READY   STATUS    RESTARTS   AGE
pod/moscow-time-app-6c97cc86f9-5g8tn   1/1     Running   0          19s
pod/moscow-time-app-6c97cc86f9-q5c29   1/1     Running   0          19s
pod/moscow-time-app-6c97cc86f9-qbmw8   1/1     Running   0          19s

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/kubernetes        ClusterIP   10.96.0.1        <none>        443/TCP          73m
service/moscow-time-app   NodePort    10.110.120.181   <none>        8080:30080/TCP   14s
```

Open the service:

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

Browser result:

![Browser result](images/browser-result.png)

Remove declarative resources:

```bash
kubectl delete -f k8s/service.yml
kubectl delete -f k8s/deployment.yml
```
