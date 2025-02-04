pipeline {
    agent any
    environment {
        AWS_REGION = "us-east-1"
        CLUSTER_NAME = "eks-monitoring"
    }
    stages {
        stage('Setup AWS Credentials & Kubeconfig') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'admin']]) {
                    sh '''
                    # Update the kubeconfig file using AWS CLI
                    aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}
                    
                    # Verify connection using kubectl
                    kubectl get nodes
                    '''
                }
            }
        }

        stage('Deploy Nginx using Helm') {
            steps {
                script {
                    // Ensure Helm is properly configured with the EKS cluster
                    sh 'helm repo add stable https://charts.helm.sh/stable'
                    sh 'helm repo update'
                    
                    // Install or upgrade the Nginx deployment using the values.yaml from the chart
                    sh '''
                    helm upgrade --install nginx ./charts/nginx \
                        --values ./charts/nginx/values.yaml
                    '''
                }
            }
        }
    }
}
