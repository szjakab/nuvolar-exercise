[
    {
      "name": "order-service",
      "image": "nuvolar/order-service:latest",
      "essential": true,
      "environment": [
        {"name": "PORT", "value": "3002"}
      ],
      "logConfiguration":{
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${loggroup}",
            "awslogs-region": "${region}",
            "awslogs-stream-prefix": "order-service"
        }
      },
      "portMappings": [
        {
          "containerPort": 3002,
          "hostPort": 3002
        }
      ],
      "dockerLabels": 
        {
          "traefik.http.routers.rule": "Host(`${alb_endpoint}`)",
          "traefik.http.routers.middlewares": "cors",
          "traefik.enable": "true",
          "traefik.http.middlewares.cors.headers.accesscontrolallowmethods": "GET,OPTIONS,PUT,POST,DELETE",
          "traefik.http.middlewares.cors.headers.accesscontrolalloworiginlist": "http://localhost:3000",
          "traefik.http.middlewares.cors.headers.accesscontrolmaxage" : "100",
          "traefik.http.middlewares.cors.headers.accesscontrolallowheaders" : "Origin,Content-Length,Content-Type",
          "traefik.http.middlewares.cors.headers.accesscontrolexposeheaders" : "X-Auth-Info",
          "traefik.http.middlewares.cors.headers.accesscontrolallowcredentials" : "true",
          "traefik.http.middlewares.cors.headers.addvaryheader": "true"
        },
    }
]
