#==================================================================
# vpc - outputs.tf
#==================================================================

output "vpc_id" {
  description = "O ID da VPC."
  value       = aws_vpc.this.id
}

output "igtw_id" {
  description = "O ID do Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "nat_id" {
  description = "O ID do NAT Gateway."
  value       = aws_nat_gateway.this[*].id
}

output "eip" {
  description = "O IP do NAT Gateway."
  value       = aws_eip.this[*].public_ip
}

output "subnet_private_id" {
  description = "O ID da Subnet Privada."
  value       = aws_subnet.subnet_private[*].id
}

output "subnet_public_id" {
  description = "O ID da Subnet Publica."
  value       = aws_subnet.subnet_public[*].id
}
