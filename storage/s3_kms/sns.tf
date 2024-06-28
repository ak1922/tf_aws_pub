# SNS topic for s3 notifications
resource "aws_sns_topic" "sns_topic" {
  name         = "s3notify"
  display_name = "s3notify"

  tags = local.module_tags
}

# SNS policy.
resource "aws_sns_topic_policy" "topic_policy" {
  policy = data.aws_iam_policy_document.sns_policy.json
  arn    = aws_sns_topic.sns_topic.arn
}

# SNS topic subsription.
resource "aws_sns_topic_subscription" "topic_subscription" {
  endpoint  = var.topic_endpoint
  protocol  = "email"
  topic_arn = aws_sns_topic.sns_topic.arn
}

# s3 bucket notification.
resource "aws_s3_bucket_notification" "bucket_notification" {
  topic {
    events    = ["s3:ObjectCreated:*"]
    topic_arn = aws_sns_topic.sns_topic.arn
  }

  bucket = aws_s3_bucket.buck.id
}
