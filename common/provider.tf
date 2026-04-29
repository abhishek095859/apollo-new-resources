provider "aws" {
  region = var.region
}
terraform {
  backend "s3" {
    bucket = "atl-apac-mum-nw-cloud-iaac-s3"
    key    = "Terraform/NONSAPProd/Common/common_resources.tfstate"
    region = "eu-central-1"
        assume_role = {
      role_arn = "arn:aws:iam::468429600765:role/ATL-APAC-MUM-NW-TERRAFORM-IAAC-IAM-ROLE"
    }
  }
}