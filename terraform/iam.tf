# EKS Cluster Role
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# Node Group Role
resource "aws_iam_role" "nodes" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "nodes_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_AWSXrayWriteOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
  role       = aws_iam_role.nodes.name
}

# Developer IAM User
resource "aws_iam_user" "developer" {
  name = "bedrock-dev-view"
  tags = var.common_tags
}

resource "aws_iam_user_policy_attachment" "developer_read_only" {
  user       = aws_iam_user.developer.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}


# CI IAM User (backend access for Terraform)
data "aws_caller_identity" "current" {}

resource "aws_iam_user" "ci" {
  name = "bedrock-ci"
  tags = var.common_tags
}

resource "aws_iam_policy" "ci_backend" {
  name        = "${var.cluster_name}-ci-backend"
  description = "Allow Terraform backend access to S3 state bucket and DynamoDB lock table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3StateBucket"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::project-bedrock-terraform-state-1166",
          "arn:aws:s3:::project-bedrock-terraform-state-1166/*"
        ]
      },
      {
        Sid    = "DynamoStateLock"
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/terraform-lock-table"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "ci_backend" {
  user       = aws_iam_user.ci.name
  policy_arn = aws_iam_policy.ci_backend.arn
}

