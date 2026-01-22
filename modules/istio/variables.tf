variable "istio_version" {
  type = string
}

variable "eks_endpoint" {
  type = string
}

variable "eks_cluster_ca_base64" {
  type = string
}

variable "eks_token" {
  type = string
}

variable "tags" {
  type = map(string)
}
