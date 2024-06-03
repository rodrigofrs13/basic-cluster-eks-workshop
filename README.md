# Cluster Amazon EKS básico para Workshops e Demos

## Setup


#### Clone do repositório execute o comando abaixo:
`git clone https://github.com/rodrigofrs13/basic-cluster-eks-workshop`

#### Acesse o diretório onde está o código Terraform.
`cd basic-cluster-eks-workshop`

#### O arquivo terraform.tfvarscontém as variáveis que podem ser ajustadas de acordo com o ambiente, antes de iniciar o setup.

- Nome do cluster

`cluster_name = "cluster-workshop"`

- Versão do cluster

`eks_version = "1.30"`

- Região AWS

`region = "us-east-1"`

- Range de IP liberado para acessar o cluster

`cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]`

- Logs habilitados no cluster

`cluster_enabled_log_types = ["api", "audit", "authenticator","controllerManager","scheduler"]`

- CIDR da VPC

`cidr = "10.0.0.0/16"`

`enable_nat_gateway = "true"`

`single_nat_gateway = "true"`

`enable_dns_hostnames = "true"`

- Versão dos Addons

`version_kube_proxy = "v1.29.0-eksbuild.1"`

`version_coredns = "v1.11.1-eksbuild.4"`

`version_vpc-cni = "v1.16.0-eksbuild.1"`

- Para efetuar o setup vamos executar o Terraform, para isso execute o comando abaixo:

`terraform init && terraform plan && terraform apply --auto-approve`


## Delete
- Ao finalizar o workshop ou a demo remova os recursos criados com o comando abaixo:

`terraform destroy --auto-approve`