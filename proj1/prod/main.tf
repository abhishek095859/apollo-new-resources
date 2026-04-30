data "aws_vpc" "devops_prod" {
  id = var.vpc_id
}
data "aws_kms_alias" "common_kms" {
  name = "alias/${var.alias_name}"
}
module "s3_bucket" {
  source = "../../module/s3"

  bucket_name             = var.s3_bucket_name
  versioning              = var.s3_versioning
  force_destroy           = var.s3_force_destroy
  block_public_acls       = var.s3_block_public_acls
  block_public_policy     = var.s3_block_public_policy
  ignore_public_acls      = var.s3_ignore_public_acls
  restrict_public_buckets = var.s3_restrict_public_buckets
  
  # Use the common tags defined at the top of your tfvars
  tags = var.common_tags
}

module "eks" {
  source = "../../module/eks"
  cluster_name  = var.cluster_name
  subnet_ids    = var.subnet_ids
  instance_type = var.instance_type
  min_size      = var.min_size
  max_size      = var.max_size
  
}

#ECR Repositories

module "ecr" {
  source = "../../module/ecr"

  for_each = var.ecr_repositories

  repository_name      = each.value.repository_name
  image_tag_mutability = each.value.image_tag_mutability
  scan_on_push         = each.value.scan_on_push
  kms_key_arn        = data.aws_kms_alias.common_kms.target_key_arn
  tags                 = each.value.tags
}
