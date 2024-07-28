
resource "aws_security_group" "ec2_instance_sg" {
  vpc_id      = var.vpc_id
  name        = "${local.resource_prefix}-security-group"
  description = "security group that allows ssh and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  dynamic ingress {
    for_each = var.require_alb == false ? [1] : []
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
resource "aws_security_group_rule" "ec2_instance_sg_ingress" {
  security_group_id        = aws_security_group.ec2_instance_sg.id
  count                    = var.require_alb == true ? 1 : 0
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2_elb_sg.id
}

locals {
  res_prefix = "${var.project_name}-${var.env_name}"
}