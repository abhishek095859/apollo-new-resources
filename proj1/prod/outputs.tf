output "kms_key_arn" {
  description = "KMS key ARN retrieved from existing common resources"
  value       = data.aws_kms_alias.nawc_kms.target_key_arn
}
