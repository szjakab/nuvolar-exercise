locals {
  # api-gateway_url = "http://${aws_service_discovery_service.api-gateway.name}.${aws_service_discovery_private_dns_namespace.ronin.name}:5000"
  api-gateway_external_url = "https://api.${local.env}.${local.root_domain}"
}

resource "aws_ecs_task_definition" "traefik" {
  family = "${local.project_name}-${local.env}-traefik"

  container_definitions = templatefile("task-definitions/traefik.json.tpl", {
    loggroup         = aws_cloudwatch_log_group.traefik.name
    region           = local.aws_region
    ecs_cluster_name = aws_ecs_cluster.main.name
  })
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs.arn
  task_role_arn            = aws_iam_role.traefik.arn
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
}

resource "aws_ecs_task_definition" "api-gateway" {
  family = "${local.project_name}-${local.env}-api-gateway"

  container_definitions = templatefile("task-definitions/api-gateway.json.tpl", {
    region          = local.aws_region
    alb_endpoint    = aws_alb.main.dns_name
    api-gateway_url = local.api-gateway_external_url
    image           = var.image
  })

  execution_role_arn       = aws_iam_role.ecs.arn
  task_role_arn            = aws_iam_role.api-gateway.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
}

resource "aws_ecs_task_definition" "customer-serivce" {
  family = "${local.project_name}-${local.env}-customer-serivce"

  container_definitions = templatefile("task-definitions/customer-serivce.json.tpl", {
    region = local.aws_region
    #alb_endpoint = aws_alb.main.dns_name
    #customer-serivce_url = local.customer-serivce_external_url
    image = var.image
  })

  execution_role_arn       = aws_iam_role.ecs.arn
  task_role_arn            = aws_iam_role.customer-serivce.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
}

resource "aws_ecs_task_definition" "order-service" {
  family = "${local.project_name}-${local.env}-order-service"

  container_definitions = templatefile("task-definitions/order-service.json.tpl", {
    region = local.aws_region
    #alb_endpoint = aws_alb.main.dns_name
    #order-service_url = local.order-service_external_url
    image = var.image
  })

  execution_role_arn       = aws_iam_role.ecs.arn
  task_role_arn            = aws_iam_role.order-service.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
}

