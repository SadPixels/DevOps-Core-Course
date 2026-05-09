# Kubernetes deployment

## Application

The repository contains a Flask Moscow Time application in `app_python/`.

Before applying Kubernetes resources, build the image inside Minikube:

```bash
minikube start --driver=docker
minikube image build -t moscow-time-app:1.0.0 ./app_python
```

## StatefulSet manifest

The standalone StatefulSet manifest is stored here:

```text
k8s/statefulset.yml
```

The Service manifest is stored here:

```text
k8s/service.yml
```

Apply resources:

```bash
kubectl apply -f k8s/service.yml
kubectl apply -f k8s/statefulset.yml
```

Check resources:

```bash
kubectl get po,sts,svc,pvc
```

Open the service:

```bash
minikube service moscow-time-app
```

Remove resources:

```bash
kubectl delete -f k8s/statefulset.yml
kubectl delete -f k8s/service.yml
```

For Helm-based deployment, use `k8s/HELM.md`.
