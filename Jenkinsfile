pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        CLUSTER_NAME = "eks-monitoring"
        KUBECONFIG_PATH = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/prabhusamarla/Prabhu-k8s.git'
            }
        }

        stage('Setup AWS Credentials & Kubeconfig') {
            steps {
                withCredentials([aws(credentialsId: 'admin', region: "${AWS_REGION}")]) {
                    sh """
                        aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}
                        kubectl get nodes
                    """
                }
            }
        }

        stage('Deploy Nginx using Kubectl') {
            steps {
                script {
                    sh """
                        kubectl apply -f deployment.yaml
                        kubectl get pods
                        kubectl get svc
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    sh """
                        kubectl rollout status deployment/nginx
                        kubectl get all
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Nginx deployment successful!"
        }
        failure {
            echo "Deployment failed. Check logs for details."
        }
    }
}
