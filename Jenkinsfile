pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred-id')
        IMAGE_NAME = 'trend-app'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Ragul0506/Guvi-Trend-app-mini-Project.git',
                    credentialsId: 'github-cred-id'
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('.') { // ensure working directory is repo root
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                dir('.') {
                    sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                    sh "docker tag ${IMAGE_NAME}:latest <your-dockerhub-username>/${IMAGE_NAME}:latest"
                    sh "docker push <your-dockerhub-username>/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                dir('.') {
                    sh "kubectl apply -f k8s/deployment.yaml"
                    sh "kubectl apply -f k8s/service.yaml"
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




