variable "instance_name" {
  type        = string
  description = "Name tag for the EC2 instance"
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use. Leave empty to auto-select latest Windows Server 2022."
  default     = ""
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to launch the instance in"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach"
}

variable "key_name" {
  type        = string
  description = "Name of the EC2 key pair"
}

variable "iam_instance_profile" {
  type        = string
  description = "Name of the IAM instance profile to attach"
  default     = ""
}

variable "root_volume_size" {
  type        = number
  description = "Root EBS volume size in GB"
  default     = 500
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key used to encrypt EBS volumes"
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
