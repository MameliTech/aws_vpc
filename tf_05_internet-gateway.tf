#==================================================================
# vpc - internet-gateway.tf
#==================================================================

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = { "Name" : local.internet_gateway }

  depends_on = [
    aws_vpc.this
  ]
}
