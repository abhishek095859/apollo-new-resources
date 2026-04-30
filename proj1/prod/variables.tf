variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_id" {
  description = "ID of the existing DevOps Prod VPC"
  type        = string
}
variable "s3_bucket_name" { type = string }
variable "s3_versioning" { type = bool }
variable "s3_force_destroy" { type = bool }
variable "s3_block_public_acls" { type = bool }
variable "s3_block_public_policy" { type = bool }
variable "s3_ignore_public_acls" { type = bool }
variable "s3_restrict_public_buckets" { type = bool }


variable "cluster_name" { type = string }
variable "subnet_ids" { type = list(string) }
variable "instance_type" { type = string }
variable "min_size" { type = number }
variable "max_size" { type = number }

variable "common_tags" {
  description = "Tags applied to every resource"
  type        = map(string)
  default     = {}
}

variable "ecr_repositories" {
  description = "Map of ECR repositories"
  type = map(object({
    repository_name      = string
    image_tag_mutability = optional(string, "MUTABLE")
    scan_on_push         = optional(bool, true)
    tags                 = optional(map(string), {})
  }))
  default = {}
}
# variable "kms_alias_name" {
#   type        = string
#   description = "The alias name of the KMS key from Common folder"
# }
variable "alias_name" {
  description = "KMS key alias"
  type        = string
}
variable "description" {
  description = "KMS key description"
  type        = string
}
