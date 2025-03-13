#==================================================================
# vpc - variables.tf
#==================================================================

#------------------------------------------------------------------
# Provider
#------------------------------------------------------------------
variable "account_region" {
  description = "Define a regiao onde os recursos serao alocados."
  type        = string
}


#------------------------------------------------------------------
# Resource Nomenclature
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
  validation {
    condition     = var.rn_environment == "dev" || var.rn_environment == "hml" || var.rn_environment == "prd" || var.rn_environment == "devops"
    error_message = "Valor invalido. Deve ser 'dev', 'hml', 'prd' ou 'devops'."
  }
}

variable "rn_role" {
  description = " Define a funcao do recurso. Limitado a 8 caracteres."
  type        = string
}


#------------------------------------------------------------------
# Network Fundation
#------------------------------------------------------------------
variable "cidr_vpc" {
  description = "Define o range de IP da VPC."
  type        = string
}

variable "availability_zone" {
  description = "Define as zonas de disponibilidade das subnets."
  type        = list(string)
}

variable "role_snet_publ" {
  description = "Define a funcao da subnet publica."
  type        = string
}

variable "role_rt_publ" {
  description = "Define a funcao do Route Table publico."
  type        = string
}

variable "cidr_subnet_publ" {
  description = "Define o range de IP da subnet publica."
  type        = list(string)
}

variable "role_snet_priv" {
  description = "Define a funcao da subnet privada."
  type        = string
}

variable "role_rt_priv" {
  description = "Define a funcao da Route Table privada."
  type        = string
}

variable "cidr_subnet_priv" {
  description = "Define o range de IP da subnet privada."
  type        = list(string)
}

variable "private_route_table" {
  description = "Configuracoes adicionais para a Route Table privada."
  type        = map(any)
  default     = {}
  nullable    = false
}

variable "unique_ngtw" {
  description = "Define se deve ser criado NAT Gateway unico (true) ou um para cada zona de disponibilidade (false)."
  type        = bool
  default     = true
  nullable    = false
}
