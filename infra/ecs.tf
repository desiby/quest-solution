resource "aws_security_group" "allow_inbound" {
  name        = "allow-inbound-quest-${terraform.workspace}"
  description = "Allow custom tcp traffic to service"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "allow http"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "quest_cluster" {
  name = "quest-${terraform.workspace}"
  tags =local.common_tags
}

resource "aws_ecs_cluster_capacity_providers" "quest_cluster_capacity_provider" {
  cluster_name = aws_ecs_cluster.quest_cluster.name
  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "quest_task_definition" {
  family = "quest"
  requires_compatibilities = ["FARGATE"]
  cpu = 256
  memory = 512
  execution_role_arn = aws_iam_role.task_execution_role.arn
  network_mode = "awsvpc"
  container_definitions = jsonencode([
    {
      name      = "questapp-${terraform.workspace}"
      image     = "desiby/questapp-beta"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      environment = [
        {
          name = "SECRET_WORD",
          value = "TwelveFactor"
        }
      ]
    }])
}

resource "aws_ecs_service" "quest_service" {
  name = "quest-service-${terraform.workspace}"
  cluster         = aws_ecs_cluster.quest_cluster.id
  task_definition = aws_ecs_task_definition.quest_task_definition.arn
  launch_type = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
    security_groups = [aws_security_group.allow_inbound.id]
    assign_public_ip = true
  }

  load_balancer {
    container_name = "questapp-${terraform.workspace}"
    container_port = 3000
    target_group_arn = aws_lb_target_group.quest_target_group.arn
  }
}

