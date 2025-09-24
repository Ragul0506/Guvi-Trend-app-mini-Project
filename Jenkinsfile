pipeline {
    agent any

    environment {
        // Jenkins credentials IDs
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred-id')   // DockerHub credentials
        GITHUB_CREDENTIALS = 'github-cred-id'                      // GitHub credentials if repo is private

        IMAGE_NAME = 'trend-app'
        DOCKERHUB_REPO = 'sarwanragul/trend-app'
        K8S_MANIFEST_DIR = 'k8s'  // Directory containing deployment.yaml & service.yaml
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Ragul0506/Guvi-Trend-app-mini-Project.git',
                    credentialsId: GITHUB_CREDENTIALS
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('.') { // Ensure current directory is repo root
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                dir('.') {
                    // Login to DockerHub
                    sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                    
                    // Tag image for DockerHub
                    sh "docker tag ${IMAGE_NAME}:latest ${DOCKERHUB_REPO}:latest"
                    
                    // Push image
                    sh "docker push ${DOCKERHUB_REPO}:latest"
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                dir('.') {
                    // Apply Kubernetes manifests
                    sh "kubectl apply -f ${K8S_MANIFEST_DIR}/deployment.yaml"
                    sh "kubectl apply -f ${K8S_MANIFEST_DIR}/service.yaml"
                }
            }
        }
    }

    post {
        failure {
            echo '❌ Deployment Failed'
        }
        success {
            echo '✅ Deployment Succeeded'
        }
    }
}






