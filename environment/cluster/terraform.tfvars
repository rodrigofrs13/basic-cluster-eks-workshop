## Dados do cluster

eks_admin_role_name                     = "workshopadmin"
cluster_name                            = "eks-workshop-basic"
kubernetes_version                      = "1.30"
region                                  = "us-east-1"
cluster_endpoint_public_access_cidrs    = ["0.0.0.0/0"]
cluster_enabled_log_types               = ["api", "audit", "authenticator","controllerManager","scheduler"]

