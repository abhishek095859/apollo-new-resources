###############################################################
# DevOps Prod – terraform.tfvars
# Fill in the values marked with REPLACE_ME before applying
###############################################################

region = "ap-south-1"

# Existing VPC – DevOps Prod
vpc_id = "vpc-04f329a5cddbeece9" 

# Existing IAM Role for EC2 instance profile
ec2_role_name = "ATL-APAC-MUM-DEVOPS-PROD-NAWC-ML-INFER-EC2-IAM-ROLE"

# ALB
#alb_name              = "ATL-MUM-NAWC-PROD-ML-ALB"
#alb_target_group_name = "ATL-MUM-NAWC-PROD-ML-TG"

# List of at least 2 private subnet IDs for the ALB (must span 2 AZs)
# alb_subnet_ids = [
#   "subnet-0528658749cbaba5e",
#   "subnet-047099ca2fa852431",
#   "subnet-059b69127d86197e2"
# ]

# KMS
alias_name  = "ATL-APAC-MUM-DEVOPS-PROD-KMS-KEY"
description = "EBS encryption key for NAWC ML Inference workloads"

# tags for ec2 applied to every ec2 resource
ec2_tags = {
  owner       = "rishabh.prasad@apollotyres.com"
  environment = "prod"
  map-migrated = "mig91CEGUP1GN"
  sourceCreation = "terraform"
  project = "NAWC"
  application = "NAWC Model Inferencing"
  Criticality = "AA"
}

# Common tags applied to every resource
common_tags = {
  owner       = "rishabh.prasad@apollotyres.com"
  environment = "prod"
  map-migrated = "mig91CEGUP1GN"
  sourceCreation = "terraform"
  project = "NAWC"
  application = "NAWC Model Inferencing"
}

###############################################################
# Security Groups
# NOTE: egress is hardcoded as allow-all in the SG module.
#       The EC2-SG ← ALB-SG cross-reference is handled by a
#       standalone aws_vpc_security_group_ingress_rule in main.tf.
###############################################################

security_groups = {

  ALB-SG = {
    name        = "ATL-APAC-MUM-DEVOPS-PROD-NAWC-ML-INFER-ALB-SG"
    description = "Security group for NAWC ML Inference internal ALB"

    ingress_rules = [
      {
        from_port = 443
        to_port   = 443
        protocol  = "tcp"
        cidr_ipv4 = "10.0.0.0/8"
      },
      {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_ipv4 = "10.0.0.0/8"
      }
    ]

    tags = {
      owner       = "rishabh.prasad@apollotyres.com"
      environment = "prod"
      map-migrated = "mig91CEGUP1GN"
      sourceCreation = "terraform"
      project = "NAWC"
      application = "NAWC Model Inferencing"
    }
  }

  # EC2 Security Group
  EC2-SG = {
    name        = "ATL-APAC-MUM-DEVOPS-PROD-NAWC-ML-INFER-EC2-SG"
    description = "Security group for NAWC ML Inference EC2 - RDP and HTTPS from ALB"

    ingress_rules = [
      # RDP from internal corporate network
      {
        from_port = 3389
        to_port   = 3389
        protocol  = "tcp"
        cidr_ipv4 = "172.18.0.0/16"
      }
      # HTTPS from ALB-SG is handled by a standalone rule in main.tf
    ]

    tags = {
      owner       = "rishabh.prasad@apollotyres.com"
      environment = "prod"
      map-migrated = "mig91CEGUP1GN"
      sourceCreation = "terraform"
      project = "NAWC"
      application = "NAWC Model Inferencing"
    }
  }
}

###############################################################
# EC2 Instances
###############################################################

ec2_instances = {

  EC2-01 = {
    name          = "ATL-APAC-MUM-DEVOPS-PROD-NAWC-ML-INFER-EC2-01"
    instance_type = "t2.micro"
    subnet_id     = "subnet-0863964745f3f084d"
    key_name           = "test-apollo"
    security_group_key = "EC2-SG"
    volume_size        = 500        
    tags = {
      owner       = "rishabh.prasad@apollotyres.com"
      environment = "prod"
      map-migrated = "mig91CEGUP1GN"
      sourceCreation = "terraform"
      project = "NAWC"
      application = "NAWC Model Inferencing"
      Criticality = "AA"
    }
  }
  EC2-02 = {
    name          = "ATL-APAC-MUM-DEVOPS-PROD-NAWC-ML-INFER-EC2-02"
    instance_type = "t2.micro"
    subnet_id     = "subnet-0266f82a0315025fc"
    key_name           = "test-apollo"
    security_group_key = "EC2-SG"
    volume_size        = 500       
    tags = {
      owner       = "rishabh.prasad@apollotyres.com"
      environment = "prod"
      map-migrated = "mig91CEGUP1GN"
      sourceCreation = "terraform"
      project = "NAWC"
      application = "NAWC Model Inferencing"
      Criticality = "AA"
    }
  }
}

# S3 Bucket Configuration
s3_bucket_name             = "atl-apac-mum-devops-prod-nawc-ml-infer-s3"
s3_versioning              = true
s3_force_destroy           = false # Set to true only if you want to delete bucket with data
s3_block_public_acls       = true
s3_block_public_policy     = true
s3_ignore_public_acls      = true
s3_restrict_public_buckets = true
