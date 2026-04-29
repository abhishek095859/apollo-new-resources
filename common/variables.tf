variable "region" {}

variable "common_tags" { type = map(string) }

variable "alias_name" {
  type        = string
  description = "The display name for the KMS key"
}
 
variable "description" {
  type        = string
  description = "The description for the KMS key"
}
