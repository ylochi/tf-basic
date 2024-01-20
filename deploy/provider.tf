terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
  profile= "yasmin"
  default_tags {
    tags = {
        terraform = true
    }
  }
}

terraform {
    backend "s3" {
        bucket = "yasmin-states-files"
        key = "web"
        region = "us-east-2"
        encrypt = true
    }

}

