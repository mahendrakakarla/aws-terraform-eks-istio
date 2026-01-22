locals {
  name = "${var.project}-${var.environment}"
  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "./modules/vpc"

  name      = local.name
  vpc_cidr  = var.vpc_cidr
  aws_region = var.aws_region
  tags      = local.tags
}

module "eks" {
  source = "./modules/eks"

  name               = local.name
  cluster_version    = var.cluster_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  tags               = local.tags
}

module "iam_alb" {
  source = "./modules/iam-alb"

  cluster_name       = module.eks.cluster_name
  oidc_provider_arn  = module.eks.oidc_provider_arn
  oidc_provider_url  = module.eks.oidc_provider_url
  tags               = local.tags
}

module "alb_controller" {
  source = "./modules/alb-controller"

  cluster_name            = module.eks.cluster_name
  region                  = var.aws_region
  vpc_id                  = module.vpc.vpc_id
  role_arn                = module.iam_alb.alb_controller_role_arn

  eks_endpoint            = data.aws_eks_cluster.this.endpoint
  eks_cluster_ca_base64   = data.aws_eks_cluster.this.certificate_authority[0].data
  eks_token               = data.aws_eks_cluster_auth.this.token

  depends_on = [module.iam_alb]
}

# Providers for kubernetes/helm need the EKS endpoint/CA/token
data "aws_eks_cluster" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "this" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

module "istio" {
  source = "./modules/istio"
  count  = var.install_istio ? 1 : 0

  istio_version = var.istio_version

  # pass providers data
  eks_endpoint                  = data.aws_eks_cluster.this.endpoint
  eks_cluster_ca_base64         = data.aws_eks_cluster.this.certificate_authority[0].data
  eks_token                     = data.aws_eks_cluster_auth.this.token

  tags = local.tags

  depends_on = [module.eks]
}
