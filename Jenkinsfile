pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        CLUSTER_NAME = "eks-monitoring"
        KUBECONFIG_PATH = "/var/lib/jenkins/.kube/config"
    }

    // Set AWS credentials globally
    options {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'admin']])
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/prabhusamarla/Prabhu-k8s.git'
            }
        }

        stage('Setup AWS Credentials & Kubeconfig') {
            steps {
                sh """
                    aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}
                    kubectl get nodes
                """
            }
        }

        stage('Deploy Nginx using Kubectl') {
            steps {
                sh """
                    kubectl apply -f deployment.yaml
                    kubectl get pods
                    kubectl get svc
                """
            }
        }

        stage('Verify Deployment') {
            steps {
                sh """
                    kubectl rollout status deployment/nginx
                    kubectl get all
                """
            }
        }
    }

    post {
        success {
            echo "✅ Nginx deployment successful!"
        }
        failure {
            echo "❌ Deployment failed. Check logs for details."
        }
    }
}
