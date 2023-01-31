
resource "aws_ecs_service" "api-gateway" {
  name = "${local.project_name}-${local.env}-api-gateway"

  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api-gateway.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups  = [aws_security_group.api-gateway.id]
    assign_public_ip = true
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.api-gateway.arn
    container_name = "api-gateway"
  }

}

resource "aws_ecs_service" "customer-service" {
  name = "${local.project_name}-${local.env}-customer-service"

  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.customer-service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups  = [aws_security_group.customer-service.id]
    assign_public_ip = true
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.customer-service.arn
    container_name = "customer-service"
  }

}

resource "aws_ecs_service" "order-service" {
  name = "${local.project_name}-${local.env}-order-service"

  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.order-service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups  = [aws_security_group.order-service.id]
    assign_public_ip = true
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.order-service.arn
    container_name = "order-service"
  }

}

resource "aws_ecs_service" "traefik" {
  depends_on = [aws_lb_target_group.traefik]

  name            = "${local.project_name}-${local.env}-traefik"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.traefik.arn
  desired_count   = 1
  launch_type     = "FARGATE"


  load_balancer {
    target_group_arn = aws_lb_target_group.traefik.arn
    container_name   = "traefik"
    container_port   = 80
  }

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups  = [aws_security_group.traefik_ecs.id]
    assign_public_ip = true
  }

}
