# ─── Public Subnets — Web Tier ─────────────────────────────
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name                                        = "${var.project}-${var.environment}-pub-sub-${count.index + 1}"
    Tier                                        = "web"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}

# ─── Private Subnets — App Tier ────────────────────────────
resource "aws_subnet" "app" {
  count = length(var.app_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.app_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(local.common_tags, {
    Name                                        = "${var.project}-${var.environment}-app-sub-${count.index + 1}"
    Tier                                        = "app"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}

# ─── Private Subnets — DB Tier ─────────────────────────────
resource "aws_subnet" "db" {
  count = length(var.db_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-db-sub-${count.index + 1}"
    Tier = "db"
  })
}