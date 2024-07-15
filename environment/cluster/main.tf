data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_iam_session_context" "current" {
  # This data source provides information on the IAM source role of an STS assumed role
  # For non-role ARNs, this data source simply passes the ARN through issuer ARN
  # Ref https://github.com/terraform-aws-modules/terraform-aws-eks/issues/2327#issuecomment-1355581682
  # Ref https://github.com/hashicorp/terraform-provider-aws/issues/28381
  arn = data.aws_caller_identity.current.arn
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", local.region]
  }
}

locals{
  name            = var.cluster_name
  region          = var.region
  cluster_version = var.kubernetes_version
  
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnets 

  authentication_mode = var.authentication_mode
  
  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/aws-samples/eks-blueprints-for-terraform-workshop"
  }  
}

data "aws_iam_role" "eks_admin_role_name" {
  name = var.eks_admin_role_name
}

################################################################################
# EKS Cluster
################################################################################
#tfsec:ignore:aws-eks-enable-control-plane-logging
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"

  cluster_name                            = var.cluster_name
  cluster_version                         = var.kubernetes_version
  cluster_enabled_log_types               = var.cluster_enabled_log_types 
  cluster_endpoint_public_access_cidrs    = var.cluster_endpoint_public_access_cidrs

  authentication_mode = local.authentication_mode
  
  # Combine root account, current user/role and additional roles to be able to access the cluster KMS key - required for terraform updates
  kms_key_administrators = distinct(concat([
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"],
    [data.aws_iam_session_context.current.issuer_arn]
  ))
  
  enable_cluster_creator_admin_permissions = true
  access_entries = {
    # One access entry with a policy associated
    eks_admin = {
      principal_arn     = data.aws_iam_role.eks_admin_role_name.arn
      policy_associations = {
        argocd = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  } 
  
  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnets

  eks_managed_node_groups = {
    initial = {
      instance_types = ["t3.medium"]

      min_size     = 3
      max_size     = 10
      desired_size = 3
    }
  }

  cluster_addons = {
    eks-pod-identity-agent = {
      most_recent = true
    }
    vpc-cni = {
      # Specify the VPC CNI addon should be deployed before compute to ensure
      # the addon is configured before data plane compute resources are created
      # See README for further details
      before_compute = true
      most_recent    = true # To ensure access to the latest settings provided
      configuration_values = jsonencode({
        env = {
          # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }  
  tags = local.tags
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--region", local.region]
    }
  }
}

# locals{
#   argocd_namespace = "argocd" 
#   environment     = "hub"
# }

# resource "kubernetes_namespace" "argocd" {
#   metadata {
#     name = local.argocd_namespace
#   }
# }
# ################################################################################
# # GitOps Bridge: Bootstrap
# ################################################################################
# module "gitops_bridge_bootstrap" {
#   source  = "gitops-bridge-dev/gitops-bridge/helm"
#   version = "0.0.1"
#   cluster = {
#     cluster_name = module.eks.cluster_name
#     environment  = local.environment
#     #enablemetadata metadata     = local.addons_metadata
#     #enablemetadata addons       = local.addons
#   }
#   #enableapps apps = local.argocd_apps
#   argocd = {
#     namespace        = local.argocd_namespace
#     chart_version    = "6.7.12"
#     timeout          = 600
#     create_namespace = false
#     set = [
#       {
#         name  = "server.service.type"
#         value = "LoadBalancer"
#       }
#     ]
#   }
  
# }
