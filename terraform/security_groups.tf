# ─── Web Tier SG ───────────────────────────────────────────
resource "aws_security_group" "web" {
  name        = "${var.project}-${var.environment}-web-sg"
  description = "Web tier - allows HTTP/HTTPS from internet"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.web_sg_ingress_rules
    content {
      description = ingress.key
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.value.cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-web-sg"
  })
}

# ─── App Tier SG ───────────────────────────────────────────
resource "aws_security_group" "app" {
  name        = "${var.project}-${var.environment}-app-sg"
  description = "App tier - EKS worker node communication"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.app_sg_ingress_rules
    content {
      description = ingress.key
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.value.cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-app-sg"
  })
}

# ─── DB Tier SG ────────────────────────────────────────────
resource "aws_security_group" "db" {
  name        = "${var.project}-${var.environment}-db-sg"
  description = "DB tier - only reachable from app tier"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.db_sg_ingress_rules
    content {
      description = ingress.key
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = [ingress.value.cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-db-sg"
  })
}