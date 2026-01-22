variable "cluster_name" { type = string }
variable "oidc_provider_arn" { type = string }
variable "oidc_provider_url" { type = string }
variable "tags" { type = map(string) }

# Pin to the official policy JSON published by kubernetes-sigs.
# You can also pin to a specific controller version path if you prefer.
variable "alb_controller_iam_policy_url" {
  type    = string
  default = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/refs/heads/main/docs/install/iam_policy.json"
}
