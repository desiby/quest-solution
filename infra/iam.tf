data "aws_iam_policy_document" "ecs_assume_task_execution_role_document" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_execution_role_policy_document" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "task_execution_role_policy" {
  policy = data.aws_iam_policy_document.task_execution_role_policy_document.json
  name = "quest-ecs-task-execution-${terraform.workspace}"
}

resource "aws_iam_role" "task_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_task_execution_role_document.json
  name = "quest-ecs-execution-role-${terraform.workspace}"
}

resource "aws_iam_role_policy_attachment" "attach_role_to_task_policy" {
  policy_arn = aws_iam_policy.task_execution_role_policy.arn
  role       = aws_iam_role.task_execution_role.name
}
