variable "name" {
  type        = string
  description = "Security group name"
}

variable "description" {
  type        = string
  description = "Security group description"
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to associate the security group with"
}

variable "ingress_rules" {
  description = "List of ingress rule objects"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_ipv4   = optional(string)
    source_sg_id = optional(string)
    description = optional(string)
  }))
  default = []
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
