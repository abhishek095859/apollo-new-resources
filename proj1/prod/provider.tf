provider "aws" {
  region = var.region
}
terraform {
  backend "s3" {
    bucket = "test-apollo-statefile-storing"
    key    = "prod/terraform.tfstate"
    region = "ap-south-1"
        assume_role = {
      role_arn = "arn:aws:iam::183295435445:role/crossaccountA"
    }
  }
}
