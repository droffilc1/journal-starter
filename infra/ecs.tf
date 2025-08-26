resource "aws_ecs_cluster" "journal" {
  name = "journal-cluster"
}

resource "aws_ecs_task_definition" "journal" {
  family                   = "journal-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "journal-app"
      image     = var.app_image
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DB_HOST"
          value = aws_instance.postgres.private_ip
        },
        {
          name  = "DB_USER"
          value = "postgres"
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "journal" {
  name            = "journal-service"
  cluster         = aws_ecs_cluster.journal.id
  task_definition = aws_ecs_task_definition.journal.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.app_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.journal_tg.arn
    container_name   = "journal-app"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.http]
}

