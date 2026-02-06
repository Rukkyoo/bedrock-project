variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
  default     = "project-bedrock-cluster"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "project-bedrock-vpc"
}

variable "student_id" {
  description = "Student ID for resource naming"
  type        = string
  default     = "1166"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project = "Bedrock"
    Grading = "barakat-2025-capstone"
  }
}
