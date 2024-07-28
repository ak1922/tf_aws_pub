# Terraform cloud backend configuration.
terraform {
  cloud {
    organization = "tf_aws_pub"

    workspaces {
      name = "compute_asg"
    }
  }
}
