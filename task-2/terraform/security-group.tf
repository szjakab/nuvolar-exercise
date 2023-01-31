resource "aws_security_group" "alb" {
  name   = "${local.project_name}-${local.env}-alb"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${local.env}-alb"
  })
}

resource "aws_security_group" "traefik_ecs" {
  name        = "traefik-ecs"
  description = "Allow http and https traffic from ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Non secured"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "Non secured"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "api-gateway" {
  name        = "api-gateway"
  description = "Allow traffic from Traefik"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Non secured"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "customer-service" {
  name        = "customer-service"
  description = "Allow traffic from Traefik"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Non secured"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "order-service" {
  name        = "order-service"
  description = "Allow traffic from Traefik"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Non secured"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}