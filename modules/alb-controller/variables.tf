variable "cluster_name" { type = string }
variable "region" { type = string }
variable "vpc_id" { type = string }
variable "role_arn" { type = string }

variable "eks_endpoint" { type = string }
variable "eks_cluster_ca_base64" { type = string }
variable "eks_token" { type = string }

# Optional: pin chart version if you want
variable "chart_version" {
  type    = string
  default = null
}
