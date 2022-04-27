resource "aws_kms_grant" "this" {
  name              = var.name_prefix
  key_id            = aws_kms_key.this.key_id
  grantee_principal = aws_iam_role.this.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_iam_role" "this" {
  name = "${var.name_prefix}-KMSGrant"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_security_group" "efs" {
  name   = "${var.name_prefix}-EFS"
  vpc_id = var.vpc_id 

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
}


resource "aws_kms_key" "this" {}

resource "aws_efs_file_system" "this" {
  kms_key_id = aws_kms_key.this.arn
  encrypted  = true
}

resource "aws_efs_mount_target" "this" {
  count           = length(var.private_subnets)
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.private_subnets[count.index]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_backup_policy" "this" {
  file_system_id = aws_efs_file_system.this.id
  backup_policy {
    status = "ENABLED"
  }
}
