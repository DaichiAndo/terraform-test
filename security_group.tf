# ==================================
# security group
# ==================================
resource "aws_security_group" "alb-sg" {
  name        = "${var.user}-${var.project}-alb-sg"
  description = "This is a security group for alb."
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.user}-${var.project}-alb-sg"
    Project = var.project
    User    = var.user
  }
}

resource "aws_security_group_rule" "alb-sg-in-http" {
  security_group_id = aws_security_group.alb-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb-sg-in-https" {
  security_group_id = aws_security_group.alb-sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb-sg-out" {
  security_group_id = aws_security_group.alb-sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "alb-ecs" {
  name        = "${var.user}-${var.project}-alb-ecs"
  description = "This is a security group for ecs."
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.user}-${var.project}-alb-ecs"
    Project = var.project
    User    = var.user
  }
}

resource "aws_security_group_rule" "alb-ecs-in-http" {
  security_group_id = aws_security_group.alb-ecs.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["192.168.0.0/20"]
}

resource "aws_security_group_rule" "alb-ecs-in-https" {
  security_group_id = aws_security_group.alb-ecs.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["192.168.0.0/20"]
}

resource "aws_security_group_rule" "alb-ecs-out" {
  security_group_id = aws_security_group.alb-ecs.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
