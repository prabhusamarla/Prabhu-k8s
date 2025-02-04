#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "Starting installation of AWS CLI, kubectl, eksctl, and Helm..."

# Install AWS CLI v2
if command_exists aws; then
    echo "AWS CLI is already installed."
else
    echo "Installing AWS CLI v2..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
    rm -rf aws awscliv2.zip
    echo "AWS CLI installed successfully."
fi

# Install kubectl v1.30
if command_exists kubectl; then
    echo "kubectl is already installed."
else
    echo "Installing kubectl v1.30..."
    curl -LO "https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    rm kubectl.sha256
    echo "kubectl installed successfully."
fi

# Install eksctl
if command_exists eksctl; then
    echo "eksctl is already installed."
else
    echo "Installing eksctl..."
    curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz"
    curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep "eksctl_Linux_amd64.tar.gz" | sha256sum --check
    tar -xvzf eksctl_Linux_amd64.tar.gz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin/
    rm eksctl_Linux_amd64.tar.gz
    echo "eksctl installed successfully."
fi

# Install Helm
if command_exists helm; then
    echo "Helm is already installed."
else
    echo "Installing Helm..."
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm get_helm.sh
    echo "Helm installed successfully."
fi

echo "All tools installed successfully!"
