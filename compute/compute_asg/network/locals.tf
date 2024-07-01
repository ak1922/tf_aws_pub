# Locals block for project tags
locals {
  module_tags = {
    managed_by  = "Terraform"
    environment = "dev"
  }
}

locals {
  aux_args = {
    vnet_name     = join("", [var.app_name, local.module_tags.environment, "-vnet"])
    subnet_prefix = join("", [var.app_name, local.module_tags.environment, "-publicsubnet"])
    table_name    = join("", [var.app_name, local.module_tags.environment, "-rt"])
    ec2sg_name    = join("", [var.app_name, local.module_tags.environment, "-ec2sg"])
    elbsg_name    = join("", [var.app_name, local.module_tags.environment, "-elbsg"])
  }
}
