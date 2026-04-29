variable "description" {
  default = "KMS Key for EBS Encryption"
}

variable "alias_name" {
  
}
variable "region" {
  type    = string
  default = "ap-south-1"
}
variable "common_tags" { type = map(string) }
