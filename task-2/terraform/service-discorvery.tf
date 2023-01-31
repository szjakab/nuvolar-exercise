resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "${local.env}.private"
  description = "${local.project_name} ${local.env} service discovery"
  vpc         = aws_vpc.vpc.id
}


resource "aws_service_discovery_service" "api-gateway" {
  name = "${local.project_name}-${local.env}-api-gateway"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "customer-service" {
  name = "${local.project_name}-${local.env}-customer-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_service" "order-service" {
  name = "${local.project_name}-${local.env}-order-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.main.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}