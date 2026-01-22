terraform {
  backend "s3" {
    bucket         = "aws_tf_state_bucket"
    key            = "eks-istio/dev/terraform.tfstate"
    region         = "aws_region"
    dynamodb_table = "aws_tf_lock_table"
    encrypt        = true
  }
}
