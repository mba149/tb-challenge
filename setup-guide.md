# 🧪 Local Setup for `tb-challenge` using Minikube

This guide walks you through setting up the `tb-challenge` application locally using [Minikube](https://minikube.sigs.k8s.io), [Helm](https://helm.sh/), Kubernetes Ingress, and a public Docker Hub image.

---

## ✅ Prerequisites

Ensure the following tools are installed on your machine:

- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [Docker](https://docs.docker.com/get-docker/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)

---

## 🧱 Step 1: Start Minikube

Start a single-node Minikube cluster using the Docker driver:

```bash
minikube start --driver=docker
```

Verify it’s running:

```bash
minikube status
```

---

## ⚙️ Step 2: Enable Ingress Addon

Enable the NGINX Ingress Controller:

```bash
minikube addons enable ingress
```

> This enables the controller in the `ingress-nginx` namespace.

---

## 📦 Step 3: Build Helm Dependencies

The application chart includes redis and metric-server as dependencies

```bash
cd helm/tb-challenge
helm dependency update
```

---

## 🚀 Step 4: Install the Helm Chart

Install your application using Helm:

```bash
helm upgrade --install tb-challenge -f values-local.yaml .
```

Make sure your `values-local.yaml` includes:

```yaml
image:
  repository: mba149/tb-challenge  # Docker Hub public image

```

---

## 🛠️ Step 5: Update `/etc/hosts`

Map the app’s domain to your local machine:

```bash
echo "127.0.0.1 tb-challenge.com" | sudo tee -a /etc/hosts
```

> This allows you to open `http://tb-challenge.com` in your browser.

---

## Step 6: Open minikube tunnel

Start a tunnel to expose services outside the cluster (run in a separate terminal):

```bash
minikube tunnel
```

> 🔐 Keep this terminal open while using the app. It allows routing traffic to the Ingress controller.

---

## 🌐 Step 7: Access the Application

Open the app in your browser:

```
http://tb-challenge.com
```

You should see the app up and running. 🎉

If it doesn't load:
- Make sure the `minikube tunnel` is still running
- Clear browser DNS cache or use incognito
- Test with:
  ```bash
  curl -H "Host: tb-challenge.com" http://localhost
  ```

---

## 🧪 Troubleshooting

### 🔍 Check if resources are running:

```bash
kubectl get pods
kubectl get svc
kubectl get ingress
```

### 🔍 Verify ingress routing:

```bash
curl -H "Host: tb-challenge.com" http://localhost
```

You should get a response from your app (not a 404 from NGINX).

### 🔍 Check if the pod is running correctly:

```bash
kubectl logs -l app.kubernetes.io/name=tb-challenge
```

---

## 🧹 Clean Up

To uninstall the app:

```bash
helm uninstall tb-challenge
```

To stop or delete the Minikube cluster:

```bash
minikube stop
minikube delete
```

---