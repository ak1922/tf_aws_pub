locals {
  module_tags = {
    cost        = "intermediate"
    managed_by  = "Terraform"
    gitrepo     = "tf_aws_repo"
    project     = "storage"
    sub_project = "storage_s3_kms"
    environment = "dev"
  }

  bucket_name = join("", [local.module_tags.project, local.module_tags.environment, random_integer.number.result])
}
