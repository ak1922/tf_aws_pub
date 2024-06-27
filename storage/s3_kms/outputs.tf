output "encryption_key_id" {
  value = aws_kms_key.encryption_key.id
}

output "s3_encrypt" {
    value = aws_s3_bucket_server_side_encryption_configuration.s3_encrypt.id
}
