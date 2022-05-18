data "template_file" "definition" {
  template = file("${path.module}/task-def/def.json")
  vars = {
    region          = var.region
    log_group       = aws_cloudwatch_log_group.task_log_group.name
    image_tag       = "${var.ecr_url}/${var.repository_name}:${var.tag}"
    definition_name = var.service_name
  }
}

# VPC ID
data "aws_vpc" "custom" {
  id = "vpc-0c29c60ca6688a0ba"
}

# ALL SUBNETS BELONGS TO VPC ID
data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.custom.id]
  }
}

data "aws_iam_policy" "task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}