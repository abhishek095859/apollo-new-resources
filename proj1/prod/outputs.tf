output "ec2_instance_ids" {
  description = "EC2 instance IDs"
  value       = { for k, v in module.ec2_instances : k => v.instance_id }
}

output "ec2_private_ips" {
  description = "Private IPs of EC2 instances"
  value       = { for k, v in module.ec2_instances : k => v.instance_private_ip }
}

output "ec2_ami_used" {
  description = "Windows Server 2022 AMI ID resolved at apply-time"
  value       = data.aws_ami.windows_2022.id
}

# output "alb_dns_name" {
#   description = "DNS name of the internal ALB"
#   value       = module.alb.alb_dns_name
# }

# output "alb_arn" {
#   description = "ARN of the internal ALB"
#   value       = module.alb.alb_arn
# }

# output "alb_target_group_arn" {
#   description = "ARN of the ALB target group"
#   value       = module.alb.target_group_arn
# }

output "security_group_ids" {
  description = "Security group IDs created"
  value       = { for k, v in module.security_groups : k => v.security_group_id }
}

#output "kms_key_arn" {
#  description = "KMS key ARN used for EBS encryption"
#  value       = module.kms.kms_key_arn
#}

output "kms_key_arn" {
  description = "KMS key ARN retrieved from existing common resources"
  value       = data.aws_kms_alias.nawc_kms.target_key_arn
}
