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

provider "random" {}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "central"
  region = "us-west-1"
}
