variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_id" {
  description = "ID of the existing DevOps Prod VPC"
  type        = string
}

variable "ec2_role_name" {
  description = "Name of the existing IAM role to attach to the EC2 instance profile"
  type        = string
}

variable "security_groups" {
  description = "Map of security groups to create"
}

variable "ec2_instances" {
  description = "Map of EC2 instances to create"
  type = map(object({
    name               = string
    instance_type      = string
    subnet_id          = string
    key_name           = string
    security_group_key = string
    volume_size        = number
    tags               = map(string)
  }))
}

# variable "alb_name" {
#   description = "Name of the internal ALB"
#   type        = string
# }

# variable "alb_target_group_name" {
#   description = "Name of the ALB target group"
#   type        = string
# }

# variable "alb_subnet_ids" {
#   description = "List of private subnet IDs for ALB placement (min 2 AZs)"
#   type        = list(string)
# }

# variable "acm_certificate_arn" {
#   description = "ARN of the ACM certificate for the ALB HTTPS listener"
#   type        = string
#   default     = ""
# }

variable "alias_name" {
  description = "KMS key alias"
  type        = string
}

variable "description" {
  description = "KMS key description"
  type        = string
}

variable "common_tags" {
  description = "Tags applied to every resource"
  type        = map(string)
  default     = {}
}

variable "ec2_tags" {
  description = "Tags applied to S3 resource"
  type        = map(string)
  default     = {}
}

variable "s3_bucket_name" { type = string }
variable "s3_versioning" { type = bool }
variable "s3_force_destroy" { type = bool }
variable "s3_block_public_acls" { type = bool }
variable "s3_block_public_policy" { type = bool }
variable "s3_ignore_public_acls" { type = bool }
variable "s3_restrict_public_buckets" { type = bool }