#==================================================================
# vpc.tf
#==================================================================
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_vpc
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { "Name" : local.vpc }
}
