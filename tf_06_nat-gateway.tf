#==================================================================
# vpc - nat-gateway.tf
#==================================================================

#------------------------------------------------------------------
# Elastic IP
#------------------------------------------------------------------
resource "aws_eip" "this" {
  count  = var.unique_ngtw ? 1 : length(var.cidr_subnet_publ)
  domain = "vpc"

  tags = { "Name" : var.unique_ngtw ? local.elastic_ip : "${local.elastic_ip}${count.index + 1}" }
}


#------------------------------------------------------------------
# NAT Gateway
#------------------------------------------------------------------
resource "aws_nat_gateway" "this" {
  count         = var.unique_ngtw ? 1 : length(var.cidr_subnet_publ)
  allocation_id = aws_eip.this[count.index].id
  subnet_id     = aws_subnet.subnet_public[count.index].id

  tags = { "Name" : var.unique_ngtw ? local.nat_gateway : "${local.nat_gateway}${count.index + 1}" }

  depends_on = [
    aws_eip.this
  ]
}
