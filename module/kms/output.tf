output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key"
  value       = aws_kms_key.this.arn # Ensure 'this' matches your resource name in main.tf
}
output "kms_key_arn" {
  description = "KMS Key ARN"
  value       = aws_kms_key.this.arn
} 