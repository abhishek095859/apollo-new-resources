###############################################################
# DevOps Prod – NAWC ML Inference
# Account : DevOps Prod
# Region  : ap-south-1 (Mumbai)
###############################################################

###############################################################
# Data Sources – look up existing resources
###############################################################

data "aws_vpc" "devops_prod" {
  id = var.vpc_id
}

data "aws_ami" "windows_2022" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_iam_role" "existing_ec2_role" {
  name = var.ec2_role_name
}

###########################################
# Data Source to find existing KMS Key
###########################################
data "aws_kms_alias" "nawc_kms" {
  name = "alias/${var.alias_name}"
}

###############################################################
# IAM Instance Profile (wraps the existing role for EC2)
###############################################################

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.ec2_role_name}-profile"
  role = data.aws_iam_role.existing_ec2_role.name
}

###############################################################
# Security Groups
###############################################################

module "security_groups" {
  source   = "../../module/security_group"
  for_each = var.security_groups

  name          = each.value.name
  description   = each.value.description
  vpc_id        = data.aws_vpc.devops_prod.id
  ingress_rules = each.value.ingress_rules
  common_tags   = each.value.tags
}

# Cross-SG rule: allow HTTPS from ALB-SG into EC2-SG
resource "aws_vpc_security_group_ingress_rule" "ec2_from_alb" {
  security_group_id            = module.security_groups["EC2-SG"].security_group_id
  referenced_security_group_id = module.security_groups["ALB-SG"].security_group_id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  description                  = "HTTPS from ALB SG"
}

###############################################################
# EC2 Instances
###############################################################

module "ec2_instances" {
  source   = "../../module/ec2"
  for_each = var.ec2_instances

  instance_name        = each.value.name
  ami_id               = data.aws_ami.windows_2022.id
  instance_type        = each.value.instance_type
  subnet_id            = each.value.subnet_id
  key_name             = each.value.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  security_group_ids   = [
    module.security_groups[each.value.security_group_key].security_group_id
  ]
  root_volume_size = each.value.volume_size
  common_tags      = var.ec2_tags
  kms_key_arn      = data.aws_kms_alias.nawc_kms.target_key_arn
}

###############################################################
# ALB 
###############################################################

# module "alb" {
#   source = "../../module/alb"

#   alb_name           = var.alb_name
#   vpc_id             = data.aws_vpc.devops_prod.id
#   subnet_ids         = var.alb_subnet_ids
#   security_group_ids = [module.security_groups["ALB-SG"].security_group_id]

#   enable_deletion_protection = false

#   ec2_instance_id = module.ec2_instances["EC2-01"].instance_id

#   acm_certificate_arn = "" # Not used by module, hardcoded to HTTP

#   common_tags = var.common_tags
# }

###########################################
# s3
###########################################
# module "s3_bucket" {
#   source = "../../module/s3"

#   bucket_name             = var.s3_bucket_name
#   versioning              = var.s3_versioning
#   force_destroy           = var.s3_force_destroy
#   block_public_acls       = var.s3_block_public_acls
#   block_public_policy     = var.s3_block_public_policy
#   ignore_public_acls      = var.s3_ignore_public_acls
#   restrict_public_buckets = var.s3_restrict_public_buckets
  
#   # Use the common tags defined at the top of your tfvars
#   tags = var.common_tags
# }