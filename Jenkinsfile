pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred-id')
        DOCKER_IMAGE = "sarwanragul/trend-app:latest"
        KUBECONFIG = '/home/ubuntu/.kube/config'   // EC2 kubeconfig path
    }

    stages {
        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/Ragul0506/Guvi-Trend-app-mini-Project.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t $DOCKER_IMAGE .
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh """
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                docker push $DOCKER_IMAGE
                """
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh """
                kubectl apply -f trend-deployment.yaml
                kubectl apply -f trend-service.yaml
                """
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful ✅'
        }
        failure {
            echo 'Deployment Failed ❌'
        }
    }
}

