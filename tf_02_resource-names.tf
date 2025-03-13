#==================================================================
# vpc - resource-names.tf
#==================================================================

#------------------------------------------------------------------
# Locals for Resource Names
#------------------------------------------------------------------
locals {
  name_prefix         = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}"
  vpc                 = "${local.name_prefix}-vpc"
  subnet_public       = "${local.name_prefix}-snet-${var.role_snet_publ}"
  subnet_private      = "${local.name_prefix}-snet-${var.role_snet_priv}"
  internet_gateway    = "${local.name_prefix}-igtw"
  elastic_ip          = "${local.name_prefix}-eip-ngtw"
  nat_gateway         = "${local.name_prefix}-ngtw"
  route_table_public  = "${local.name_prefix}-rt-${var.role_snet_publ}"
  route_table_private = "${local.name_prefix}-rt-${var.role_snet_priv}"
}
