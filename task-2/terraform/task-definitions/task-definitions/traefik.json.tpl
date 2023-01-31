[
    {
      "name": "traefik",
      "image": "traefik:v2.8.0",
      "entryPoint": ["traefik", "--providers.ecs.clusters", "${ecs_cluster_name}", "--log.level", "DEBUG", "--providers.ecs.region", "${region}", "--api.insecure", "--entryPoints.web.address=:80", "--entryPoints.web.forwardedHeaders.insecure"],
      "essential": true,
      "logConfiguration":{
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${loggroup}",
            "awslogs-region": "${region}",
            "awslogs-stream-prefix": "traefik"
        }
      },
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        },
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ]
    }
  ]
