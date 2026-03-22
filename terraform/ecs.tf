resource "aws_ecs_cluster" "app_cluster" {
  name = "github-actions-cluster"
}

resource "aws_security_group" "ecs_security_group" {
  name        = "ecs_security_group"
  description = "Allow inbound traffic to ECS tasks"

  ingress {
    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = var.grafana_port
    to_port     = var.grafana_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = var.prometheus_port
    to_port     = var.prometheus_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
} 

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRoletest"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "app_task" {
  family = "github-actions-task"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = "512"
  memory = "1024"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name = "app"
      image = "${aws_ecr_repository.app_repository.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort = 5000
          protocol = "tcp"
        },
        {
          containerport = 8000
          hostPort = 8000
          protocol = "tcp"
        }
      ]
    },
    {
      name = "prometheus"
      image = "${aws_ecr_repository.prometheus_repository.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 9090
          hostPort = 9090
          protocol = "tcp"
        }
      ]
    },
    {
      name = "grafana"
      image = "grafana/grafana:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort = 3000
          protocol = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "grafana_service" {
  name            = "monitoring-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.ecs_security_group.id]
    assign_public_ip = true
  }
}