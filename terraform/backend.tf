terraform {
  backend "s3" {
    bucket         = "project-bedrock-terraform-state-1166"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table" 
    encrypt        = true
  }
}
