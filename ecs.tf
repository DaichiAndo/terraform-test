# ==================================
# ecs
# ==================================
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "nginx-cluster"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.user}-nginx-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region : "ap-northeast-1"
          awslogs-group : aws_cloudwatch_log_group.nginx_log.name
          awslogs-stream-prefix : "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on      = [aws_lb_listener_rule.alb_listener_rule_http]
  network_configuration {
    subnets = [
      aws_subnet.private_subnet_1a.id,
      aws_subnet.private_subnet_1c.id
    ]
    security_groups  = [aws_security_group.alb-ecs.id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    container_name   = "nginx"
    container_port   = 80
  }
}
