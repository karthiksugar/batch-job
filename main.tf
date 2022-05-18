# ECS CLUSTER
resource "aws_ecs_cluster" "cluster" {
  name = "${var.cluster_name}-cluster"
}

# CLOUDWATCH LOG GROUP FOR ECS TASK
resource "aws_cloudwatch_log_group" "task_log_group" {
  retention_in_days = 1
  name_prefix       = "${local.service_name}-"
}

# ECS SERVICE
resource "aws_ecs_service" "service" {
  name                               = "${var.service_name}-service"
  task_definition                    = aws_ecs_task_definition.definition.arn
  cluster                            = aws_ecs_cluster.cluster.id
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 0
  launch_type                        = "FARGATE"
  network_configuration {
    subnets          = data.aws_subnets.all.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs.id]
  }
}

# ECS TASK DEFINITION
resource "aws_ecs_task_definition" "definition" {
  family                   = var.service_name
  container_definitions    = data.template_file.definition.rendered
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.service_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
}

# CLOUD WATCH EVENT SCHEDULE
resource "aws_cloudwatch_event_rule" "scheduled_task" {
  name                = "scheduled-ecs-event-rule"
  schedule_expression = "rate(5 minutes)"
}

# CLOUD WATCH EVENT TARGET
resource "aws_cloudwatch_event_target" "scheduled_task" {
  target_id = "${local.service_name}-target"
  rule      = aws_cloudwatch_event_rule.scheduled_task.name
  arn       = aws_ecs_cluster.cluster.arn
  role_arn  = aws_iam_role.scheduled_task_cloudwatch.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.definition.arn
    launch_type         = "FARGATE"
    network_configuration {
      subnets          = data.aws_subnets.all.ids
      assign_public_ip = true
      security_groups  = [aws_security_group.ecs.id]
    }
  }
}

# SECURITY GROUP FOR ECS
resource "aws_security_group" "ecs" {
  vpc_id = "vpc-0c29c60ca6688a0ba"
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }
}