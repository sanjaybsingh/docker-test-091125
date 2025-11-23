pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials') // Configure in Jenkins
        DOCKER_IMAGE = 'sanjaybsingh/nginx-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
        KUBECONFIG_CREDENTIALS = credentials('kubeconfig') // Configure in Jenkins
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from repository...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE}:${IMAGE_TAG}"
                    bat "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
                    bat "docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest"
                }
            }
        }
        
        stage('Login to Docker Hub') {
            steps {
                script {
                    echo 'Logging into Docker Hub...'
                    bat "echo %DOCKER_HUB_CREDENTIALS_PSW% | docker login -u %DOCKER_HUB_CREDENTIALS_USR% --password-stdin"
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    echo "Pushing Docker image to Docker Hub..."
                    bat "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
                    bat "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
        
        stage('Update Kubernetes Deployment') {
            steps {
                script {
                    echo 'Updating Kubernetes deployment...'
                    bat """
                        kubectl apply -f deployment.yaml
                        kubectl set image deployment/nginx-deployment nginx=${DOCKER_IMAGE}:${IMAGE_TAG}
                        kubectl rollout status deployment/nginx-deployment
                    """
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    echo 'Verifying deployment...'
                    bat """
                        kubectl get deployments
                        kubectl get pods -l app=nginx
                        kubectl get services nginx-service
                    """
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
            echo "Deployed image: ${DOCKER_IMAGE}:${IMAGE_TAG}"
        }
        failure {
            echo 'Pipeline failed!'
        }
        always {
            script {
                echo 'Cleaning up Docker images...'
                bat "docker rmi ${DOCKER_IMAGE}:${IMAGE_TAG} || exit 0"
                bat 'docker logout'
            }
        }
    }
}
