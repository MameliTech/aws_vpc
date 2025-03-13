#==================================================================
# vpc - subnets.tf
#==================================================================

#------------------------------------------------------------------
# Subnet Public
#------------------------------------------------------------------
resource "aws_subnet" "subnet_public" {
  count = length(var.cidr_subnet_publ)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.cidr_subnet_publ[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = { "Name" : "${local.subnet_public}${element(split("-", var.availability_zone[count.index]), 2)}" }

  depends_on = [
    aws_vpc.this
  ]
}


#------------------------------------------------------------------
# Subnet Private
#------------------------------------------------------------------
resource "aws_subnet" "subnet_private" {
  count = length(var.cidr_subnet_priv)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.cidr_subnet_priv[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = { "Name" : "${local.subnet_private}${element(split("-", var.availability_zone[count.index]), 2)}" }

  depends_on = [
    aws_vpc.this
  ]
}
