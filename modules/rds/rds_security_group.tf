
resource "aws_security_group" "rds-mysql-sg" {
  vpc_id      = var.vpc_id
  name        = "${local.resource_prefix}-db-sg"
  description = "security group that allows ssh and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [var.ec2_instance_sg_id]

  }
  # Adding lifecyle ignore flag so that the test environment can update the ingress rules.
  # It does associate a risk that if the rules are manually modified then it may not be dected by terraform
  lifecycle {
    ignore_changes = [ingress]
  }
}

locals {
  resource_prefix = "${var.project_name}-${var.env_name}"
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "${var.project_name}-${var.env_name}-db_subnet_grp"
  subnet_ids = [
    var.dbsubnet_01,
    var.dbsubnet_02,
  ]

  tags = {
    Name = "My DB subnet group"
  }
}