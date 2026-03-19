terraform {
  backend "s3" {
    bucket         = "bharathi-tf-state-bucket-123"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}