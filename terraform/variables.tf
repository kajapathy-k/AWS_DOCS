# ─── General ───────────────────────────────────────────────
variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "project" {
  type        = string
  description = "Project name used in all resource names and tags"
}

variable "environment" {
  type        = string
  description = "Environment name e.g. dev, staging, prod"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name — used in subnet tags for future EKS"
}

# ─── VPC ───────────────────────────────────────────────────
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

# ─── Subnets — list(string) ────────────────────────────────
variable "availability_zones" {
  type        = list(string)
  description = "List of AZs to spread subnets across"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public (web tier) subnets"
}

variable "app_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private app tier subnets (EKS nodes later)"
}

variable "db_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private DB tier subnets"
}

# ─── Security Groups — map(object) ────────────────────────
variable "web_sg_ingress_rules" {
  type = map(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr      = string
  }))
  description = "Ingress rules for Web tier security group"
}

variable "app_sg_ingress_rules" {
  type = map(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr      = string
  }))
  description = "Ingress rules for App tier security group (EKS nodes)"
}

variable "db_sg_ingress_rules" {
  type = map(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr      = string
  }))
  description = "Ingress rules for DB tier security group"
}