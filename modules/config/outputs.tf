output "project_name" {
  value = try(var.project_name)
}

output "env_name" {
  value = try(var.env_name)
}

output "keypair" {
  value = try(aws_key_pair.instance-pair.key_name)
}

output "ssh_secret_store" {
  value = try(aws_secretsmanager_secret.ssh-secrets.name)
}

output "env_secrets_store" {
  value = try(aws_secretsmanager_secret.env-secrets.name)
}