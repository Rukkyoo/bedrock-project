---
description: How to deploy Project Bedrock infrastructure and application
---

This workflow guides you through the process of provisioning the AWS infrastructure and deploying the Retail Store application.

### Prerequisites

- AWS CLI configured with administrator credentials.
- Terraform, Kubectl, and Helm installed.

### Step 1: Initialize and Apply Terraform

Navigate to the terraform directory and run the deployment.

```powershell
cd terraform
terraform init
terraform apply -auto-approve
```

### Step 2: Configure K8s Access

Update your local kubeconfig to point to the new EKS cluster.

```powershell
aws eks update-kubeconfig --region us-east-1 --name project-bedrock-cluster
```

### Step 3: Deploy the Retail Store App

Create the namespace and install the application using Helm.

```powershell
# Create the namespace
kubectl create namespace retail-app

# Install the app with in-cluster dependencies
helm install retail-app oci://public.ecr.aws/aws-containers/retail-store-sample-chart `
  --namespace retail-app `
  -f ../k8s/helm-values.yaml
```

### Step 4: Generate Grading Data

Export the infrastructure details to a JSON file for automated grading.

```powershell
cd terraform
terraform output -json > ../grading.json
```

### Step 5: Verify Deployment

Check the status of the pods.

```powershell
kubectl get pods -n retail-app
```
