
output "name" {
  value       = var.name
}

output "cidr" {
  value       = var.cidr
}

output "public_azs" {
  value       = var.public_azs
}

output "public_subnets" {
  value       = var.public_subnets
}

output "private_azs" {
  value       = var.private_azs
}

output "private_subnets" {
  value       = var.private_subnets
}

output "vpc_id" {
  value       = concat(aws_vpc.this.*.id, [""])[0]
}

output "vpc_arn" {
  value       = concat(aws_vpc.this.*.arn, [""])[0]
}

output "vpc_cidr_block" {
  value       = concat(aws_vpc.this.*.cidr_block, [""])[0]
}


output "private_subnet_arns" {
  value       = aws_subnet.private.*.arn
}

output "private_subnets_cidr_blocks" {
  value       = aws_subnet.private.*.cidr_block
}


output "nat_ids" {
  value       = aws_eip.nat.*.id
}

output "nat_public_ips" {
  value       = aws_eip.nat.*.public_ip
}

output "natgw_ids" {
  value       = aws_nat_gateway.this.*.id
}

output "igw_id" {
  value       = concat(aws_internet_gateway.this.*.id, [""])[0]
}

output "public_route_table_ids" {
  value       = aws_route_table.public.*.id
}

output "default_security_group_id" {
  value       = aws_default_security_group.default.id
}
