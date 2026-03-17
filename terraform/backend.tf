terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-45678"
    key            = "github-actions-demo/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}