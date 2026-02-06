# Project Bedrock - InnovateMart EKS Deployment

This repository contains the Infrastructure as Code (IaC) and automation for InnovateMart's inaugural EKS deployment.

## Project Structure

- `terraform/`: AWS infrastructure defined using Terraform.
- `lambda/`: Python code for the asset processor.
- `k8s/`: Helm values and Kubernetes manifests.
- `.github/workflows/`: CI/CD pipeline configuration.

## Prerequisites

- AWS CLI configured with administrator access.
- Terraform >= 1.0
- Kubectl
- Helm

## Deployment Instructions

### 1. Provision Infrastructure

Initialize and apply the Terraform configuration:

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

### 2. Deploy Application

Configure kubectl and install the Retail Store Sample App:

```bash
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster
kubectl create namespace retail-app
helm install retail-app oci://public.ecr.aws/aws-containers/retail-store-sample-chart --namespace retail-app -f k8s/helm-values.yaml
```

### 3. Generate Grading Data

Run the following command to assist the automated grading script:

```bash
cd terraform
terraform output -json > grading.json
```

## Security & Access

- **Developer Access**: Use the `bedrock-dev-view` IAM user credentials (found in Terraform outputs) to access the cluster with read-only permissions.
- **RBAC**: The user is mapped to the `view` ClusterRole within the `retail-app` namespace.

## Observability

- **CloudWatch Logs**: EKS Control Plane logs and container logs are automatically shipped to CloudWatch.
- **Add-on**: The `amazon-cloudwatch-observability` add-on is installed on the EKS cluster.

## Serverless Integration

- Upload images to the `bedrock-assets-*` S3 bucket.
- The `bedrock-asset-processor` Lambda function will log "Image received: [filename]" to CloudWatch.
