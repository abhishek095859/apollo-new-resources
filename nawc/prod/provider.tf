provider "aws" {
  region = var.region
}
terraform {
  backend "s3" {
    bucket = "atl-apac-mum-nw-cloud-iaac-s3"
    key    = "Terraform/DevOpsProd/NAWC_ML_INFER/nawc_ml_infer.tfstate"
    region = "ap-south-1"
        assume_role = {
      role_arn = "arn:aws:iam::468429600765:role/ATL-APAC-MUM-NW-TERRAFORM-IAAC-IAM-ROLE"
    }
  }
}