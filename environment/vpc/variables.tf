variable "environment_name" {
  description = "The name of environment Infrastructure stack, feel free to rename it. Used for cluster and VPC names."
  type        = string
  default     = "eks-blueprint"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = ""
}



variable "enable_igw" {
  description = "Habilitar Internet Gateway"
  type        = string
  default     = ""
}

variable "enable_nat_gateway" {
  description = "Habilitar NAT Gateway"
  type        = string
  default     = ""
}

variable "single_nat_gateway" {
  description = "Habilitar NAT Gateway"
  type        = string
  default     = ""
}

variable "enable_dns_hostnames" {
  description = "Habilitar DNS Hostname"
  type        = string
  default     = ""
}
