# KMS key for s3 encryption.
resource "aws_kms_key" "encryption_key" {
  description             = "KMS for s3 bucket encryption."
  enable_key_rotation     = true
  deletion_window_in_days = 7

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Id      = "root_policy"
      Statement = [
        {
          Sid    = "root_policy"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          },
          Action   = "kms:*"
          Resource = "*"
        },

        {
          Sid    = "admin_policy"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/ak"
          },
          Action = [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:TagResource",
            "kms:UntagResource",
            "kms:ScheduleKeyDeletion",
            "kms:CancelKeyDeletion",
            "kms:RotateKeyOnDemand"
          ]
          Resource = "*"
        },
      ]
    }
  )
}
