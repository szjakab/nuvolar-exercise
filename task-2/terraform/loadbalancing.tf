resource "aws_alb" "main" {
  name                       = "${local.project_name}-${local.env}-alb"
  internal                   = false
  enable_deletion_protection = false
  load_balancer_type         = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.subnet_a_public.id,
    aws_subnet.subnet_b_public.id,
  ]

  tags = local.common_tags
}

resource "aws_lb_target_group" "traefik" {
  name = "${local.project_name}-${local.env}-tg-traefik"

  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    matcher = "200-499"
  }

  tags = local.common_tags
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_alb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
