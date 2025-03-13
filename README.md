# AWS VPC - Virtual Private Cloud

![Provedor](https://img.shields.io/badge/provider-AWS-orange) ![Engine](https://img.shields.io/badge/engine-VPC-blueviolet) ![Versão](https://img.shields.io/badge/version-1.0.0-success) ![Coordenação](https://img.shields.io/badge/coord.-Mameli_Tech-informational)<br>

Módulo desenvolvido para o provisionamento de **AWS Virtual Private Cloud**.

Este módulo tem como objetivo criar uma VPC seguindo os padrões da Mameli Tech.

Serão criados os seguintes recursos:
1. **VPC** com o nome no padrão <span style="font-size: 12px;">`Squad-Aplicação-Ambiente-Papel-vpc`</span>
2. **Subnets** com o nome no padrão <span style="font-size: 12px;">`Squad-Aplicação-Ambiente-Papel-snet-PapelAZ`</span>
3. **Internet Gateway** com o nome no padrão <span style="font-size: 12px;">`Squad-Aplicação-Ambiente-Papel-igtw-Papel`</span>
4. **NAT Gateway** com o nome no padrão <span style="font-size: 12px;">`Squad-Aplicação-Ambiente-Papel-ngtw-Papel`</span>
5. **Route Tables** com o nome no padrão <span style="font-size: 12px;">`Squad-Aplicação-Ambiente-Papel-rt-Papel`</span>

## Como utilizar?

### Passo 1

Precisamos configurar o Terraform para armazenar o estado dos recursos criados.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_01_backend.tf` com o conteúdo abaixo:

```hcl
#==================================================================
# backend.tf - Script de definicao do Backend
#==================================================================

terraform {
  backend "s3" {
    encrypt = true
  }
}
```

### Passo 2

Precisamos armazenar as definições de variáveis que serão utilizadas pelo Terraform.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_02_variables.tf` com o conteúdo a seguir.<br>
Caso exista, adicione o conteúdo abaixo no arquivo:

```hcl
#==================================================================
# variables.tf - Script de definicao de Variaveis
#==================================================================

#------------------------------------------------------------------
# Provider
#------------------------------------------------------------------
variable "account_region" {
  description = "Regiao onde os recursos serao alocados."
  type        = string
  default     = "us-east-1"
  nullable    = false
}

variable "profile" {
  description = "Perfil AWS."
  type        = string
  default     = "devops"
  nullable    = false
}


#------------------------------------------------------------------
# Resource Nomenclature & Tags
#------------------------------------------------------------------
variable "rn_squad" {
  description = "Nome da squad. Limitado a 8 caracteres."
  type        = string
}

variable "rn_application" {
  description = "Nome da aplicacao. Limitado a 8 caracteres."
  type        = string
}

variable "rn_environment" {
  description = "Acronimo do ambiente (dev/hml/prd/devops). Limitado a 6 caracteres."
  type        = string
}

variable "default_tags" {
  description = "TAGs padrao que serao adicionadas a todos os recursos."
  type        = map(string)
}


#------------------------------------------------------------------
# VPC
#------------------------------------------------------------------
variable "vpc" {
  type = map(object({
    rn_role             = string
    cidr_vpc            = string
    availability_zone   = list(string)
    role_snet_publ      = string
    role_rt_publ        = string
    cidr_subnet_publ    = list(string)
    role_snet_priv      = string
    role_rt_priv        = string
    cidr_subnet_priv    = list(string)
    private_route_table = optional(map(any))
    unique_ngtw         = optional(bool)
  }))
}
```

### Passo 3

Precisamos configurar informar o Terraform em qual região os recursos serão implementados.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_03_provider.tf` com o conteúdo abaixo:

```hcl
#==================================================================
# provider.tf - Script de definicao do Provider
#==================================================================

provider "aws" {
  region  = var.account_region
  profile = var.profile

  default_tags {
    tags = merge(
      var.default_tags,
      {
        "T_time" : var.rn_squad
        "T_applicacao" : var.rn_application
        "T_ambiente" : var.rn_environment
        "A_provisionamento" : "terraform"
      }
    )
  }
}
```

### Passo 4

O script abaixo será responsável pela chamada do módulo.<br>
Crie um arquivo no padrão `tf_NN_vpc.tf` com o conteúdo abaixo:

```hcl
#==================================================================
# vpc.tf - Script de chamada do modulo VPC
#==================================================================

module "vpc" {
  source   = "git@github.com:MameliTech/aws_vpc.git"
  for_each = var.vpc

  account_region      = var.account_region
  rn_squad            = var.rn_squad
  rn_application      = var.rn_application
  rn_environment      = var.rn_environment
  rn_role             = each.value.rn_role
  cidr_vpc            = each.value.cidr_vpc
  availability_zone   = each.value.availability_zone
  role_snet_publ      = each.value.role_snet_publ
  role_rt_publ        = each.value.role_rt_publ
  cidr_subnet_publ    = each.value.cidr_subnet_publ
  role_snet_priv      = each.value.role_snet_priv
  role_rt_priv        = each.value.role_rt_priv
  cidr_subnet_priv    = each.value.cidr_subnet_priv
  private_route_table = each.value.private_route_table
  unique_ngtw         = each.value.unique_ngtw
}
```

### Passo 5

O script abaixo será responsável por gerar os Outputs dos recursos criados.<br>
Crie um arquivo no padrão `tf_99_outputs.tf` e adicione:

```hcl
#==================================================================
# outputs.tf - Script para geracao de Outputs
#==================================================================

output "all_outputs" {
  description = "Todos os outputs do modulo VPC."
  value       = module.vpc
}
```

### Passo 6

Adicione uma pasta env com os arquivos `dev.tfvars`, `hml.tfvars` e `prd.tfvars`. Em cada um destes arquivos você irá informar os valores das variáveis que o módulo utiliza.

Segue um exemplo do conteúdo de um arquivo `tfvars`:

```hcl
#==================================================================
# dev.tfvars - Arquivo de definicao de Valores de Variaveis
#==================================================================

#------------------------------------------------------------------
# Provider
#------------------------------------------------------------------
account_region = "us-east-1"
profile        = "devops"


#------------------------------------------------------------------
# Resource Nomenclature & Tags
#------------------------------------------------------------------
rn_squad       = "devops"
rn_application = "sap"
rn_environment = "dev"

default_tags = {
  "N_projeto" : "DevOps Lab"                                                            # Nome do projeto
  "N_ccusto_ti" : "Mameli-TI-2025"                                                      # Centro de Custo TI
  "N_ccusto_neg" : "Mameli-Business-2025"                                               # Centro de Custo Negocio
  "N_info" : "Para maiores informacoes procure a Mameli Tech - consultor@mameli.com.br" # Informacoes adicionais
  "T_funcao" : "VPC principal"                                                          # Funcao do recurso
  "T_versao" : "1.0"                                                                    # Versao de provisionamento do ambiente
  "T_backup" : "nao"                                                                    # Descritivo se sera realizado backup automaticamente dos recursos provisionados
}


#------------------------------------------------------------------
# VPC
#------------------------------------------------------------------
vpc = {
  main = {
    rn_role             = "main"
    cidr_vpc            = "10.1.0.0/16"
    availability_zone   = ["us-east-1a", "us-east-1b", "us-east-1c"]
    role_snet_publ      = "publ"
    role_rt_publ        = "publ"
    cidr_subnet_publ    = ["10.1.1.0/24", "10.1.2.0/24"]
    role_snet_priv      = "priv"
    role_rt_priv        = "priv"
    cidr_subnet_priv    = ["10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24"]
    private_route_table = {}
    unique_ngtw         = true
  }
}
```

<br>

## Provedores

| Nome | Versão |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.84.0 |

## Recursos

| Nome | Tipo |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route_table.route_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.route_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_rt_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_rt_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.subnet_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.subnet_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Entradas do módulo

| Nome | Descrição | Tipo | Padrão | Obrigatório |
|------|-------------|------|---------|:--------:|
| <a name="input_account_region"></a> [account\_region](#input\_account\_region) | Define a regiao onde os recursos serao alocados. | `string` | n/a | yes |
| <a name="input_rn_squad"></a> [rn\_squad](#input\_rn\_squad) | Nome da squad. Limitado a 8 caracteres. | `string` | n/a | yes |
| <a name="input_rn_application"></a> [rn\_application](#input\_rn\_application) | Nome da aplicacao. Limitado a 8 caracteres. | `string` | n/a | yes |
| <a name="input_rn_environment"></a> [rn\_environment](#input\_rn\_environment) | Acronimo do ambiente (dev/hml/prd/devops). Limitado a 6 caracteres. | `string` | n/a | yes |
| <a name="input_rn_role"></a> [rn\_role](#input\_rn\_role) | Define a funcao do recurso. Limitado a 8 caracteres. | `string` | n/a | yes |
| <a name="input_cidr_vpc"></a> [cidr\_vpc](#input\_cidr\_vpc) | Define o range de IP da VPC. | `string` | n/a | yes |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Define as zonas de disponibilidade das subnets. | `list(string)` | n/a | yes |
| <a name="input_role_snet_publ"></a> [role\_snet\_publ](#input\_role\_snet\_publ) | Define a funcao da subnet publica. | `string` | n/a | yes |
| <a name="input_role_rt_publ"></a> [role\_rt\_publ](#input\_role\_rt\_publ) | Define a funcao do Route Table publico. | `string` | n/a | yes |
| <a name="input_cidr_subnet_publ"></a> [cidr\_subnet\_publ](#input\_cidr\_subnet\_publ) | Define o range de IP da subnet publica. | `list(string)` | n/a | yes |
| <a name="input_role_snet_priv"></a> [role\_snet\_priv](#input\_role\_snet\_priv) | Define a funcao da subnet privada. | `string` | n/a | yes |
| <a name="input_role_rt_priv"></a> [role\_rt\_priv](#input\_role\_rt\_priv) | Define a funcao da Route Table privada. | `string` | n/a | yes |
| <a name="input_cidr_subnet_priv"></a> [cidr\_subnet\_priv](#input\_cidr\_subnet\_priv) | Define o range de IP da subnet privada. | `list(string)` | n/a | yes |
| <a name="input_private_route_table"></a> [private\_route\_table](#input\_private\_route\_table) | Configuracoes adicionais para a Route Table privada. | `map(any)` | {} | no |
| <a name="input_unique_ngtw"></a> [unique\_ngtw](#input\_unique\_ngtw) | Define se deve ser criado NAT Gateway unico (true) ou um para cada zona de disponibilidade (false). | `bool` | true | no |

## Saída dos módulos

| Nome | Descrição |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | O ID da VPC. |
| <a name="output_igtw_id"></a> [igtw\_id](#output\_igtw\_id) | O ID do Internet Gateway. |
| <a name="output_nat_id"></a> [nat\_id](#output\_nat\_id) | O ID do NAT Gateway. |
| <a name="output_eip"></a> [eip](#output\_eip) | O IP do NAT Gateway. |
| <a name="output_subnet_private_id"></a> [subnet\_private\_id](#output\_subnet\_private\_id) | O ID da Subnet Privada. |
| <a name="output_subnet_public_id"></a> [subnet\_public\_id](#output\_subnet\_public\_id) | O ID da Subnet Publica. |

<br><br><hr>

<div align="right">

<strong> Data da última versão: &emsp; 09/03/2025 </strong>

</div>
