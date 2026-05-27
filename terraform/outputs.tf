output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = aws_vpc.main.cidr_block
}

output "igw_id" {
  description = "IGW ID"
  value       = aws_internet_gateway.igw.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = [for s in aws_subnet.public : s.id]
}

output "app_subnet_ids" {
  description = "App subnet IDs"
  value       = [for s in aws_subnet.app : s.id]
}

output "db_subnet_ids" {
  description = "DB subnet IDs"
  value       = [for s in aws_subnet.db : s.id]
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = [for n in aws_nat_gateway.nat : n.id]
}

output "eip_public_ips" {
  description = "EIP public IPs"
  value       = [for e in aws_eip.nat : e.public_ip]
}

output "security_group_ids" {
  description = "SG IDs by tier"
  value = tomap({
    web = aws_security_group.web.id
    app = aws_security_group.app.id
    db  = aws_security_group.db.id
  })
}

output "public_rt_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}

output "app_rt_ids" {
  description = "App route table IDs"
  value       = [for rt in aws_route_table.app : rt.id]
}

output "db_rt_ids" {
  description = "DB route table IDs"
  value       = [for rt in aws_route_table.db : rt.id]
}