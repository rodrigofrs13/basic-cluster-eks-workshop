# Cluster Amazon EKS básico para Workshops e Demos

## Setup


#### Clone do repositório execute o comando abaixo:
`git clone https://github.com/rodrigofrs13/basic-cluster-eks-workshop`

#### Acesse o diretório onde está o código Terraform.
`cd basic-cluster-eks-workshop`

#### Vamos criar a VPC, acesse o diretório abaixo:
`cd /environment/vpc`


#### O arquivo terraform.tfvarscontém as variáveis que podem ser ajustadas de acordo com o ambiente, antes de iniciar o setup.


`vpc_cidr  = "10.0.0.0/16"`

`enable_nat_gateway = "true"`

`single_nat_gateway = "true"`

`enable_dns_hostnames = "true"`

`environment_name                        = "eks-workshop-basic"`

- Para efetuar o setup vamos executar o Terraform, para isso execute o comando abaixo:

`terraform init && terraform plan && terraform apply --auto-approve`


#### Agora vamos criar o Cluster EKS, acesse o diretório abaixo:
`cd /environment/cluster`

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


- Para efetuar o setup vamos executar o Terraform, para isso execute o comando abaixo:

`terraform init && terraform plan && terraform apply --auto-approve`

#### Acesse o cluster

- No output do Terraform existe uma saída com o comando para conectar no cluster, algo assim?
` aws eks --region us-east-1 update-kubeconfig --name"cluster-name" --alias hub`


## Delete
- Ao finalizar o workshop ou a demo remova os recursos criados com o comando abaixo:

`terraform destroy --auto-approve`