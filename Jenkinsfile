pipeline {
    agent any

    environment {
        // DockerHub credentials stored in Jenkins
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred-id') 
        IMAGE_NAME = 'sarwanragul/trend-app:latest'
        AWS_REGION = 'ap-south-1'
        EKS_CLUSTER = 'trend-eks-cluster'
        K8S_DIR = 'k8s'
    }

    stages {

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t trend-app:latest .
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-cred-id', 
                                                 passwordVariable: 'DOCKERHUB_PSW', 
                                                 usernameVariable: 'DOCKERHUB_USER')]) {
                    sh """
                        echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USER --password-stdin
                        docker tag trend-app:latest $IMAGE_NAME
                        docker push $IMAGE_NAME
                    """
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                // AWS credentials stored in Jenkins
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                  credentialsId: 'aws-eks-cred']]) {
                    sh """
                        # Update kubeconfig to talk to EKS
                        aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER
                        
                        # Apply Kubernetes manifests
                        kubectl apply -f $K8S_DIR/deployment.yaml
                        kubectl apply -f $K8S_DIR/service.yaml
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment succeeded!"
        }
        failure {
            echo "❌ Deployment failed!"
        }
    }
}







