resource "aws_ecs_cluster" "n8n_cluster" {
  name = "${var.project_name}-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.project_name}-cluster"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project_name}-task-execution-role"

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

resource "aws_cloudwatch_log_group" "n8n_logs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 30

  tags = {
    Name        = "${var.project_name}-logs"
    Environment = var.environment
    Project     = var.project_name
  }
}

# EFS File System for persistent data
resource "aws_efs_file_system" "n8n_data" {
  creation_token = "${var.project_name}-efs"
  encrypted      = true

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name        = "${var.project_name}-efs"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "${var.project_name}-efs-sg"
  description = "Security group for n8n EFS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049 # NFS port
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [var.security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-efs-sg"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_efs_mount_target" "n8n_efs_mount" {
  count = length(var.public_subnets)

  file_system_id  = aws_efs_file_system.n8n_data.id
  subnet_id       = var.public_subnets[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_ecs_task_definition" "n8n_task" {
  family                   = "${var.project_name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  
  volume {
    name = "n8n-data"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.n8n_data.id
      root_directory = "/"
    }
  }

  container_definitions = jsonencode([
    {
      name      = "${var.project_name}-container"
      image     = var.n8n_image
      essential = true
      
      mountPoints = [
        {
          sourceVolume  = "n8n-data"
          containerPath = "/data"
          readOnly      = false
        }
      ]
      
      portMappings = [
        {
          containerPort = var.n8n_port
          hostPort      = var.n8n_port
          protocol      = "tcp"
        }
      ]
      
      environment = [
        {
          name  = "N8N_PORT"
          value = tostring(var.n8n_port)
        },
        {
          name  = "N8N_PROTOCOL"
          value = "http"
        },
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "N8N_SECURE_COOKIE"
          value = "false"
        },
        {
          name  = "DB_TYPE"
          value = "sqlite"
        },
        {
          name  = "DB_SQLITE_PATH"
          value = "/data/database.sqlite"
        },
        {
          name  = "N8N_USER_FOLDER"
          value = "/data"
        },
        {
          name  = "N8N_DISABLE_PRODUCTION_MAIN_PROCESS"
          value = "true"
        },
        {
          name  = "N8N_HOST"
          value = "0.0.0.0"
        }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.n8n_logs.name
          "awslogs-region"        = "eu-west-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "${var.project_name}-task"
    Environment = var.environment
    Project     = var.project_name
  }
  
  depends_on = [aws_efs_mount_target.n8n_efs_mount]
}

resource "aws_ecs_service" "n8n_service" {
  name                 = "${var.project_name}-service"
  cluster              = aws_ecs_cluster.n8n_cluster.id
  task_definition      = aws_ecs_task_definition.n8n_task.arn
  desired_count        = 1
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  force_new_deployment = true

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  tags = {
    Name        = "${var.project_name}-service"
    Environment = var.environment
    Project     = var.project_name
  }
}