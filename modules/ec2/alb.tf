resource "aws_lb" "elb" {
  name               = "${var.project_name}-${var.env_name}-app-lb"
  internal           = false
  load_balancer_type = "application"
  count              = var.require_alb == true ? 1 : 0

  security_groups = [
  aws_security_group.ec2_elb_sg]
  subnets = [
  var.subnet_id_public_01, var.subnet_id_public_02]

  tags = {
    Name        = var.project_name
    Environment = var.env_name
  }
}

resource "aws_lb_listener" "ec2_listner" {
  load_balancer_arn = aws_lb.elb[0].arn
  count             = var.require_alb == true ? 1 : 0
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_tg[0].arn
  }
}

resource "aws_lb_target_group_attachment" "alb_attach" {
  target_group_arn = aws_lb_target_group.ec2_tg[0].arn
  count            = var.require_alb == true ? 1 : 0
  target_id        = aws_instance.ec2-web.private_ip
  port             = 80
}

resource "aws_lb_target_group" "ec2_tg" {
  count       = var.require_alb == true ? 1 : 0
  name        = "${local.resource_prefix}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  stickiness {
    type = "lb_cookie"
  }
  health_check {
    enabled             = true
    interval            = 20
    path                = "/"
    timeout             = 10
    matcher             = "200"
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

}


resource "aws_security_group" "ec2_elb_sg" {
  vpc_id      = var.vpc_id
  name        = "${local.resource_prefix}-sg"
  description = "security group that allows http, https traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.resource_prefix}-sg"
  }
}

resource "aws_lb_listener_certificate" "ec2_crt" {
  count           = var.require_alb == true ? 1 : 0
  listener_arn    = aws_lb_listener.ec2_listner[0].arn
  certificate_arn = var.certificate_arn
}
