output "mysql_host" {
  value = try(aws_db_instance.mysql_db.address, null)
}


output "rds_secret" {
  value = try(aws_secretsmanager_secret.db-secrets.name)
}

output "rds_sg_id" {
  value = try(aws_security_group.rds-mysql-sg.id)
}