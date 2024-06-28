# Random number.
resource "random_integer" "number" {
  max = 4
  min = 2
}

# s3 bucket
resource "aws_s3_bucket" "buck" {
  bucket              = local.bucket_name
  object_lock_enabled = true

  tags = merge({ "Name" = local.bucket_name }, local.module_tags)
}

# IAM role and https access.
resource "aws_iam_role" "assume_role" {
  name = "${aws_s3_bucket.buck.bucket}-AssumeRole"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = "sts:AssumeRole"
          Sid    = ""
          Principal = {
            Service = "s3.amazonaws.com"
          }
          Condition = {
            Bool = {
              "aws:SecureTransport" = true
            }
          }
        },
      ]
    }
  )

  tags = local.module_tags
}

# s3 bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encrypt" {
  bucket = aws_s3_bucket.buck.bucket

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.encryption_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# s3 bucket versioning.
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  versioning_configuration {
    status = "Enabled"
  }

  bucket = aws_s3_bucket.buck.id
}

# Block public access from s3 bucket.
resource "aws_s3_bucket_public_access_block" "public_block" {
  restrict_public_buckets = true
  ignore_public_acls = true
  block_public_acls = true
  block_public_policy = true

  bucket = aws_s3_bucket.buck.bucket
}
