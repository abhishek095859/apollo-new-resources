variable "alb_name" {
  type        = string
  description = "Name for the Application Load Balancer"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to associate with the ALB target group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the ALB (must span ≥ 2 AZs)"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs to attach to the ALB"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate to use on the HTTPS listener"
}

variable "ec2_instance_id" {
  type        = string
  description = "EC2 instance ID to register in the target group"
}

variable "enable_deletion_protection" {
  type        = bool
  description = "Enable deletion protection on the ALB"
  default     = false
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
