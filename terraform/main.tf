terraform {
  required_version = "1.0.5"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      "Project"     = "Serverless REST API Example"
      "Created At"  = "2021-09-05"
      "Managed By"  = "Terraform"
      "Owner"       = "Dantas"
      "Environment" = var.environment
    }
  }
}
