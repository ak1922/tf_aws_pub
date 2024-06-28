output "encryption_key_id" {
  value = aws_kms_key.encryption_key.id
}

output "s3_encrypt_id" {
  value = aws_s3_bucket_server_side_encryption_configuration.s3_encrypt.id
}

output "snstopic_arn" {
  value = aws_sns_topic.sns_topic.arn
}

output "topicpolicy_id" {
  value = aws_sns_topic_policy.topic_policy.id
}

output "buck_policy_id" {
  value = aws_s3_bucket_policy.buck_policy.id
}
