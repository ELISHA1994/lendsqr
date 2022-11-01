terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }

    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }

  backend "s3" {
      bucket = "terraform-state-devops-lendsqr"
      key    = "demo-backend.tfstate"
      region = "us-east-1"
  }
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "lendsqr-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "central"
  region = "us-west-1"
}
