output "cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_name" {
  description = "EKS Cluster name"
  value       = aws_eks_cluster.this.name
}

output "region" {
  description = "AWS Region"
  value       = var.region
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "assets_bucket_name" {
  description = "S3 bucket for assets"
  value       = aws_s3_bucket.assets.id
}

output "dev_access_key" {
  description = "Access Key ID for bedrock-dev-view user"
  value       = aws_iam_access_key.developer_key.id
}

output "dev_secret_key" {
  description = "Secret Access Key for bedrock-dev-view user"
  value       = aws_iam_access_key.developer_key.secret
  sensitive   = true
}
