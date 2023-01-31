resource "aws_iam_role" "traefik" {
  name = "${local.project_name}-${local.env}-traefik"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "traefik_policy" {
  name = "${local.project_name}-${local.env}-traefik"
  role = aws_iam_role.traefik.id

  policy = data.aws_iam_policy_document.traefik_policy.json
}

data "aws_iam_policy_document" "traefik_policy" {
  statement {
    sid = "main"

    actions = [
      "ecs:ListClusters",
      "ecs:DescribeClusters",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeTaskDefinition",
      "ec2:DescribeInstances"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role" "backend" {
  for_each = local.envs

  name = "${local.project_name}-${local.env}-${each.key}-backend"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  inline_policy {
    name   = "s3-bucket-access"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectAttributes",
          "s3:ListBucket",
          "s3:DeleteObject"
      ],
      "Resource": [
        "${aws_s3_bucket.private[each.key].arn}/*",
        "${aws_s3_bucket.public[each.key].arn}/*"
      ],
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  }

  inline_policy {
    name   = "ses-access"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ses:SendEmail"
            ],
            "Resource": [ 
              "${aws_ses_domain_identity.default.arn}"
            ],
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
  }

}


resource "aws_iam_role" "ecs" {
  name = "${local.project_name}-${local.env}-ecs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  inline_policy {
    name = "get-pull-secret"

    policy = <<EOF
{
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "${aws_secretsmanager_secret_version.sc_pull_secret.arn}"
      ]
}  
EOF
  }

}

resource "aws_iam_role_policy_attachment" "ecs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs.name
}

resource "aws_iam_role_policy_attachment" "ecs_policy_secrets" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.ecs.name
}


resource "aws_iam_role_policy_attachment" "ecs_policy_task_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs.name
}
