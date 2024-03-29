resource "aws_iam_role" "task_role" {
  name_prefix        = "task_role_"
  assume_role_policy = file("${path.module}/policies/task-role.json")
}

resource "aws_iam_role_policy" "task_execution" {
  role   = aws_iam_role.task_role.id
  name   = "AmazonECSTaskExecutionRolePolicy"
  policy = data.aws_iam_policy.task_execution.policy
}

resource "aws_iam_role" "service_role" {
  name_prefix        = "service_role_"
  assume_role_policy = file("${path.module}/policies/service-role.json")
}

resource "aws_iam_role_policy" "ecs_execution" {
  role   = aws_iam_role.service_role.id
  name   = "AmazonECSTaskExecutionRolePolicy"
  policy = data.aws_iam_policy.task_execution.policy
}

resource "aws_iam_role" "scheduled_task_cloudwatch" {
  name               = "${local.service_name}-cloudwatch-role"
  assume_role_policy = file("${path.module}/policies/scheduled-task-cloudwatch-role.json")
}

resource "aws_iam_role_policy" "scheduled_task_cloudwatch_policy" {
  name   = "${local.service_name}-cloudwatch-policy"
  role   = aws_iam_role.scheduled_task_cloudwatch.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:RunTask"
      ],
      "Resource": [
        "${replace(aws_ecs_task_definition.definition.arn, "/:\\d+$/", ":*")}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}