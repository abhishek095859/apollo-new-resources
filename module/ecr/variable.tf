variable "repository_name" {
  type        = string
  description = "ECR repository name"
}

variable "image_tag_mutability" {
  type    = string
  default = "MUTABLE"
}

variable "scan_on_push" {
  type    = bool
  default = true
}
variable "kms_key_arn" {
  description = "KMS key for ECR encryption"
  type        = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
