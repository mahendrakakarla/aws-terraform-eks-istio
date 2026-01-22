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

resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  version    = var.istio_version

  namespace        = "istio-system"
  create_namespace = true
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = var.istio_version

  namespace  = "istio-system"
  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  version    = var.istio_version

  namespace        = "istio-ingress"
  create_namespace = true

  # Create a LoadBalancer Service in EKS. In production you may add annotations.
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  depends_on = [helm_release.istiod]
}
