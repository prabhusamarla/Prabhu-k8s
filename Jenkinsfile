pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        CLUSTER_NAME = "eks-monitoring"
        KUBECONFIG_PATH = "/var/lib/jenkins/.kube/config"
    }

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

        stage('Deploy Nginx using Helm') {
            steps {
                sh """
                    helm repo add stable https://charts.helm.sh/stable || true
                    helm repo update
                    helm upgrade --install nginx ./_scm_helm/nginx --values ./_scm_helm/nginx/values.yaml
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
            echo "✅ Nginx deployment via Helm successful!"
        }
        failure {
            echo "❌ Deployment failed. Check logs for details."
        }
    }
}
