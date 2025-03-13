#==================================================================
# vpc - route-table.tf
#==================================================================

#------------------------------------------------------------------
# Route Table Public
#------------------------------------------------------------------
resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = { "Name" : local.route_table_public }

  depends_on = [
    aws_internet_gateway.this
  ]
}


#------------------------------------------------------------------
# Route Table Public - Association
#------------------------------------------------------------------
resource "aws_route_table_association" "public_rt_association" {
  count = length(aws_subnet.subnet_public)

  subnet_id      = aws_subnet.subnet_public[count.index].id
  route_table_id = aws_route_table.route_public.id
}


#------------------------------------------------------------------
# Route Table Private
#------------------------------------------------------------------
resource "aws_route_table" "route_private" {
  count  = var.unique_ngtw ? 1 : length(var.cidr_subnet_publ)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  dynamic "route" {
    for_each = var.private_route_table
    content {
      cidr_block = route.value.cidr_block
      gateway_id = route.value.gateway_id
    }
  }

  tags = { "Name" : var.unique_ngtw ? local.route_table_private : "${local.route_table_private}${count.index + 1}" }

  depends_on = [
    aws_nat_gateway.this
  ]
}


#------------------------------------------------------------------
# Route Table Private - Association
#------------------------------------------------------------------
resource "aws_route_table_association" "private_rt_association" {
  count = length(aws_subnet.subnet_private)

  subnet_id      = aws_subnet.subnet_private[count.index].id
  route_table_id = var.unique_ngtw ? aws_route_table.route_private[0].id : aws_route_table.route_private[count.index].id
}
