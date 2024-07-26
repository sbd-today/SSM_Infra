resource "aws_db_instance" "mysql_db" {
  allocated_storage    = 10
  identifier = "${local.resource_prefix}-db"
  engine                 = "mysql"
  engine_version         = "8.0.35"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = random_password.db_password.result
  snapshot_identifier    = try("${var.rds_snapshot_identifier}", null)
  parameter_group_name   = aws_db_parameter_group.mysql_db_parametergroup.name
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds-mysql-sg.id]
  storage_encrypted      = false

    tags = {
    app_name    = var.tagname
    type        = "db"
    environment = "${var.env_name}"
  }
}


resource "aws_ssm_parameter" "secret" {
  name        = "/${var.project_name}/${var.env_name}/mysql/password/master"
  description = "The parameter store for mysql password"
  type        = "SecureString"
  value       = random_password.db_password.result

  tags = {
    environment = var.env_name
  }
}

resource "random_password" "db_password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>.:?"
}

resource "random_uuid" "prefix" {
}

resource "aws_secretsmanager_secret" "db-secrets" {
  name                           = "${var.project_name}-${var.env_name}-db-secrets"
  force_overwrite_replica_secret = true
  recovery_window_in_days        = 0

}

resource "aws_secretsmanager_secret_version" "current" {
  secret_id     = aws_secretsmanager_secret.db-secrets.id
  secret_string = random_password.db_password.result
}


resource "aws_db_parameter_group" "mysql_db_parametergroup" {
  name   = "${var.project_name}-${var.env_name}-db-sg"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}