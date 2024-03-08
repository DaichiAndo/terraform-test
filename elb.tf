# ==================================
# elb
# ==================================
resource "aws_lb" "alb" {
  name               = "${var.user}-${var.project}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb-sg.id
  ]
  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id,
  ]
}

resource "aws_lb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "${var.user}-${var.project}-alb-tg"
  vpc_id      = aws_vpc.vpc.id
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  health_check {
    path = "/"
    port = 80
  }

  tags = {
    Name    = "${var.user}-${var.project}-alb-tg"
    Project = var.project
    User    = var.user
  }
}

resource "aws_lb_listener_rule" "alb_listener_rule_http" {
  listener_arn = aws_lb_listener.alb_listener_http.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
