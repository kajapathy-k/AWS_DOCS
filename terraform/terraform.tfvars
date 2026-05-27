# ─── General ───────────────────────────────────────────────
aws_region   = "ap-south-1" # ← Mumbai region
project      = "e3t"
environment  = "dev"
cluster_name = "e3t-eks-cluster"

# ─── VPC ───────────────────────────────────────────────────
vpc_cidr = "10.0.0.0/16"

# ─── Subnets ───────────────────────────────────────────────
availability_zones  = ["ap-south-1a", "ap-south-1b"] # ← Mumbai AZs
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
app_subnet_cidrs    = ["10.0.11.0/24", "10.0.12.0/24"]
db_subnet_cidrs     = ["10.0.21.0/24", "10.0.22.0/24"]

# ─── Security Group Rules ───────────────────────────────────
web_sg_ingress_rules = {
  http  = { from_port = 80, to_port = 80, protocol = "tcp", cidr = "0.0.0.0/0" }
  https = { from_port = 443, to_port = 443, protocol = "tcp", cidr = "0.0.0.0/0" }
}

app_sg_ingress_rules = {
  api_port = { from_port = 8080, to_port = 8080, protocol = "tcp", cidr = "10.0.0.0/16" }
  kubelet  = { from_port = 10250, to_port = 10250, protocol = "tcp", cidr = "10.0.0.0/16" }
  dns_tcp  = { from_port = 53, to_port = 53, protocol = "tcp", cidr = "10.0.0.0/16" }
  dns_udp  = { from_port = 53, to_port = 53, protocol = "udp", cidr = "10.0.0.0/16" }
}

db_sg_ingress_rules = {
  mysql    = { from_port = 3306, to_port = 3306, protocol = "tcp", cidr = "10.0.0.0/16" }
  postgres = { from_port = 5432, to_port = 5432, protocol = "tcp", cidr = "10.0.0.0/16" }
}