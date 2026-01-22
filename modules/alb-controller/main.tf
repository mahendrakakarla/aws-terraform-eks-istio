provider "kubernetes" {
  host                   = var.eks_endpoint
  cluster_ca_certificate = base64decode(var.eks_cluster_ca_base64)
  token                  = var.eks_token
}

provider "helm" {
  kubernetes {
    host                   = var.eks_endpoint
    cluster_ca_certificate = base64decode(var.eks_cluster_ca_base64)
    token                  = var.eks_token
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  dynamic "version" {
    for_each = var.chart_version == null ? [] : [1]
    content  = var.chart_version
  }

  set { name = "clusterName"; value = var.cluster_name }
  set { name = "region"; value = var.region }
  set { name = "vpcId"; value = var.vpc_id }

  # IRSA: create SA + attach role annotation
  set { name = "serviceAccount.create"; value = "true" }
  set { name = "serviceAccount.name"; value = "aws-load-balancer-controller" }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.role_arn
  }
}
