# Nginx Docker & Kubernetes Deployment

This project contains a Dockerized Nginx application with Kubernetes deployment configuration and Jenkins CI/CD pipeline.

## Project Structure

```
.
├── Dockerfile              # Docker configuration for Nginx
├── deployment.yaml         # Kubernetes deployment and service configuration
├── Jenkinsfile            # Jenkins CI/CD pipeline
└── README.md              # This file
```

## Prerequisites

- Docker Desktop with Kubernetes enabled
- kubectl CLI tool
- Docker Hub account
- Jenkins (optional, for CI/CD)

## Quick Start

### 1. Build Docker Image

```bash
docker build -t sanjaybsingh/nginx-app:latest .
```

### 2. Run Locally with Docker

```bash
docker run -d -p 8080:80 sanjaybsingh/nginx-app:latest
```

Access at: http://localhost:8080

### 3. Push to Docker Hub

```bash
docker login -u sanjaybsingh
docker push sanjaybsingh/nginx-app:latest
```

## Kubernetes Deployment

### Switch to Docker Desktop Context

```bash
kubectl config use-context docker-desktop
```

### Deploy to Kubernetes

```bash
kubectl apply -f deployment.yaml
```

### Verify Deployment

```bash
kubectl get deployments
kubectl get services
kubectl get pods
```

### Access the Application

The service is exposed on NodePort 30080:
- http://localhost:30080

### Check Deployment Status

```bash
kubectl describe deployment nginx-deployment
kubectl describe service nginx-service
```

## Kubernetes Resources

### Deployment
- **Name**: nginx-deployment
- **Replicas**: 3
- **Image**: sanjaybsingh/nginx-app:latest
- **Container Port**: 80
- **Resource Limits**: 
  - Memory: 128Mi
  - CPU: 500m
- **Resource Requests**: 
  - Memory: 64Mi
  - CPU: 250m

### Service
- **Name**: nginx-service
- **Type**: NodePort
- **Port**: 80
- **NodePort**: 30080
- **Target Port**: 80

## Jenkins Pipeline

The `Jenkinsfile` contains a complete CI/CD pipeline that:

1. Checks out code
2. Builds Docker image
3. Pushes to Docker Hub
4. Deploys to Kubernetes
5. Verifies deployment

### Jenkins Setup

**Required Credentials:**
- `dockerhub-credentials`: Docker Hub username/password
- `kubeconfig`: Kubernetes config file (optional)

**Required Plugins:**
- Docker Pipeline
- Kubernetes CLI
- Git

## Cleanup

### Delete Kubernetes Resources

```bash
kubectl delete -f deployment.yaml
```

Or delete individually:

```bash
kubectl delete deployment nginx-deployment
kubectl delete service nginx-service
```

### Remove Docker Images

```bash
docker rmi sanjaybsingh/nginx-app:latest
```

### Verify Cleanup

```bash
kubectl get all
docker images | grep nginx-app
```

## Troubleshooting

### Cannot connect to Kubernetes cluster

Ensure you're using the correct context:
```bash
kubectl config current-context
kubectl config use-context docker-desktop
```

### Port already in use

Check what's using the port:
```bash
netstat -ano | findstr :30080
```

### Pods not starting

Check pod logs:
```bash
kubectl logs <pod-name>
kubectl describe pod <pod-name>
```

### Service not accessible

Verify endpoints:
```bash
kubectl get endpoints nginx-service
kubectl describe service nginx-service
```

## Docker Hub Repository

Image available at: https://hub.docker.com/r/sanjaybsingh/nginx-app

## Additional Commands

### Scale Deployment

```bash
kubectl scale deployment nginx-deployment --replicas=5
```

### Update Image

```bash
kubectl set image deployment/nginx-deployment nginx=sanjaybsingh/nginx-app:v2
```

### Rollback Deployment

```bash
kubectl rollout undo deployment/nginx-deployment
```

### View Deployment History

```bash
kubectl rollout history deployment/nginx-deployment
```

## License

This project is open source and available for educational purposes.
