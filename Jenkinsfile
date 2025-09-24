pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "sarwanragul/trend-app:latest"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh 'kubectl apply -f k8s/trend-deployment.yaml'
                sh 'kubectl apply -f k8s/trend-service.yaml'
            }
        }
    }

    post {
        failure {
            echo "❌ Deployment Failed"
        }
        success {
            echo "✅ Deployment Successful"
        }
    }
}


