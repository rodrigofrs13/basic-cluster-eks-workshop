variable "kubernetes_version" {
  description = "EKS version"
  type        = string
  default     = ""
}


variable "cluster_name" {
  description = "Cluster Name"
  type        = string
  default     = ""
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = ""
}

variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
  default     = []
}


variable "cluster_endpoint_public_access_cidrs" {
  description = "A list of Allow Public IP"
  type        = list(string)
  default     = []
}


variable "eks_admin_role_name" {
  description = "EKS admin role"
  type        = string
  default     = ""
}

variable "addons" {
  description = "EKS addons"
  type        = any
  default = {
    enable_aws_load_balancer_controller = false
    enable_aws_argocd = false
  }
}

variable "authentication_mode" {
  description = "The authentication mode for the cluster. Valid values are CONFIG_MAP, API or API_AND_CONFIG_MAP"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

