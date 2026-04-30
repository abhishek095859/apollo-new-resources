output "ec2_instance_ids" {
  description = "EC2 instance IDs"
  value       = { for k, v in module.ec2_instances : k => v.instance_id }
}

output "ec2_private_ips" {
  description = "Private IPs of EC2 instances"
  value       = { for k, v in module.ec2_instances : k => v.instance_private_ip }
}

# UPDATE THIS BLOCK
output "ec2_ami_used" {
  description = "Windows Server 2019 AMI ID resolved at apply-time"
  value       = data.aws_ami.windows_2019.id
}

output "security_group_ids" {
  description = "Security group IDs created"
  value       = { for k, v in module.security_groups : k => v.security_group_id }
}

output "kms_key_arn" {
  description = "KMS key ARN retrieved from existing common resources"
  value       = data.aws_kms_alias.nawc_kms.target_key_arn
}
