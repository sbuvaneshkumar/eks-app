output "aws_kms_key_arn" {
    value = aws_kms_key.this.arn
  }

output "efs_id" {
  value = aws_efs_file_system.this.id
}
