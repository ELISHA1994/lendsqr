##EKS Cluster ID
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

##EKS Cluster auth
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

##Kubernetes provider
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate  = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  #  load_config_file         = false
}


module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name    = local.cluster_name
  cluster_version = "1.22"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    attach_cluster_primary_security_group = true

    # Disabling and using externally provided security groups
    create_security_group = false
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-one"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      pre_bootstrap_user_data = <<-EOT
      echo 'foo bar'
      EOT

      vpc_security_group_ids = [
        aws_security_group.node_group_one.id,
      ]
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1

      pre_bootstrap_user_data = <<-EOT
      echo 'foo bar'
      EOT

      vpc_security_group_ids = [
        aws_security_group.node_group_two.id
      ]
    }
  }

  write_kubeconfig = true
  config_output_path = "./"
}

## Get Bucket
data "aws_s3_bucket" "get_bucket" {
  bucket = "terraform-state-devops-lendsqr"
}

## S3 Bucket Object Upload
resource "aws_s3_object" "object" {
  bucket = data.aws_s3_bucket.get_bucket.id
  key    = module.eks.kubeconfig_filename
  source = "./${module.eks.kubeconfig_filename}"
}
