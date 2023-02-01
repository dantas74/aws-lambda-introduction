provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      "Project"     = "Serverless REST API Example"
      "Created At"  = "2023-02-01"
      "Managed By"  = "Terraform"
      "Owner"       = "Dantas"
      "Environment" = var.env
    }
  }
}
