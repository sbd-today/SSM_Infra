
resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

resource "random_uuid" "prefix" {
}
resource "aws_secretsmanager_secret" "ssh-secrets" {
  name                           = "${var.project_name}-${var.env_name}-ssh-${random_uuid.prefix.result}"
  force_overwrite_replica_secret = true
}

resource "aws_secretsmanager_secret_version" "current" {
  secret_id     = aws_secretsmanager_secret.ssh-secrets.id
  secret_string = tls_private_key.ssh.private_key_openssh
}


resource "aws_key_pair" "instance-pair" {
  key_name   = "${var.project_name}-${var.env_name}-keypair"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_secretsmanager_secret" "env-secrets" {
  force_overwrite_replica_secret = true
  name                           = "${var.project_name}-${var.env_name}-secrets"
  recovery_window_in_days        = 0
}
