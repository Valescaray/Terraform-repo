terraform {
  backend "s3" {
    bucket         = "invoice-analyzer-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "invoice-analyzer-terraform-locks"
  }
}
