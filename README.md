# AWS EKS + Istio (Terraform)

## What this repo does
- Provisions AWS networking (VPC, subnets, NAT) using Terraform modules
- Provisions an EKS cluster + managed node group
- Installs Istio (base, istiod, ingress gateway) via Helm provider

## What this repo does NOT do
- Does not deploy application workloads
- Does not manage Istio VirtualService/DestinationRule routing rules (kept in app repo)
- Does not include any credentials or tfstate

## Usage (optional)
1) Configure AWS credentials (SSO or env vars)
2) Create S3 + DynamoDB for remote state (recommended)
3) terraform init && terraform plan && terraform apply

#Folder layout

aws-terraform-eks-istio/
├── README.md
├── .gitignore
├── versions.tf
├── backend.tf
├── providers.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── eks/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── istio/
    |   ├── main.tf
    |   ├── variables.tf
    |   └── outputs.tf
    ├── iam-alb/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── alb-controller/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
