# Data source current user.
data "aws_caller_identity" "current" {}

# Data source IAM policy document for SNS topic
data "aws_iam_policy_document" "sns_policy" {
  policy_id = "s3notify_policy"

  statement {
    sid    = "s3notify_policy"
    effect = "Allow"

    resources = [
      aws_sns_topic.sns_topic.arn
    ]

    principals {
      type = "Service"
      identifiers = [
        "s3.amazonaws.com"
      ]
    }

    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]
  }
}

# s3 bucket access policy.
data "aws_iam_policy_document" "s3bucket_policy" {
  policy_id = "s3_bucket_access"

  statement {
    sid = "admin_access"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/ak"
      ]
    }

    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.buck.bucket}/*"
    ]

    actions = [
      "s3:*"
    ]
  }
}
