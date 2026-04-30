region = "eu-central-1"

# Existing VPC – DevOps Prod
vpc_id = "vpc-03e53b3b1376d65b7" 

description = "EBS encryption key for NAWC EKS workloads"
#kms_alias_name = "ATL-APAC-MUM-DIH-KMS-KEY-01"
alias_name  = "ATL-EUR-FRNK-NON-SAP-PROD-KMS-KEY"

common_tags = {
  owner       = "rishabh.prasad@apollotyres.com"
  environment = "prod"
  map-migrated = "mig91CEGUP1GN"
  sourceCreation = "terraform"
  project = "NAWC"
  application = "NAWC EKS"
  Criticality = "AA"
}

# S3 Bucket Configuration
s3_bucket_name             = "atl-apac-mum-devops-prod-nawc-eks-s3"
s3_versioning              = true
s3_force_destroy           = false # Set to true only if you want to delete bucket with data
s3_block_public_acls       = true
s3_block_public_policy     = true
s3_ignore_public_acls      = true
s3_restrict_public_buckets = true

###########
#eks
########


cluster_name  = "ATL-APAC-MUM-DEVOPS-PROD-NAWC-PROD-EKS-CLUSTER"
instance_type = "m8g.large"
min_size      = 1
max_size      = 3

# Use the Subnet IDs created in your console
subnet_ids = [
  "subnet-03898eff7f85a98eb", 
  "subnet-089767f0caecf1df7",
]


#######################
#ECR Repo
#######################

ecr_repositories = {
  Ecr-01 = {
    repository_name = "atl-apac-mum-devops-prod-nawc-ecr-repo"
    tag_mutability  = "MUTABLE"
    scan_on_push    = true

    tags = {
      owner       = "rishabh.prasad@apollotyres.com"
      environment = "prod"
      map-migrated = "mig91CEGUP1GN"
      sourceCreation = "terraform"
      project = "NAWC"
      application = "NAWC EKS"
      Criticality = "AA"
    }
  }
}
