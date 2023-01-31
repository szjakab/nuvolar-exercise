terraform {
  required_version = "~> 1.0"

  backend "s3" {
    bucket = "tfstates-nuvolar"
    key    = "npn.tfstate"
    region = "eu-central-1"
  }
  required_providers {
    aws = {
      source  = "aws"
      version = ">= 4.24.0"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
