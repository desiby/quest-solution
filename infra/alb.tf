resource "aws_security_group" "allow_http" {
  name        = "allow-http-quest-${terraform.workspace}"
  description = "Allow http traffic to lb"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "allow http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "quest_target_group" {
  health_check {
    interval = 30
    path = "/"
    port = "3000"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 2
    healthy_threshold = 5
    matcher = "200"
  }
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = module.vpc.vpc_id
  name = "quest-tg-${terraform.workspace}"
}

resource "aws_lb" "quest_alb" {
  name = "quest-lb-${terraform.workspace}"
  load_balancer_type = "application"
  subnets = [
    module.vpc.public_subnets[0],
    module.vpc.public_subnets[1]
  ]
  security_groups = [aws_security_group.allow_http.id]
}

resource "aws_lb_listener" "quest_lb_listener" {
  load_balancer_arn = aws_lb.quest_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.quest_target_group.arn
    type = "forward"
  }
}
