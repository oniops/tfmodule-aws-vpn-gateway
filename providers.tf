terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 6.0"
    }
  }
}

# Refers to environment variables [AWS_PROFILE, AWS_REGION].
provider "aws" {
  region = module.ctx.region
}
