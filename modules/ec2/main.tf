

data "aws_secretsmanager_secret" "sm" {
  name = var.ssh_secret_store
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.sm.id
}

resource "aws_instance" "ec2-web" {
  ami           = var.ami_id
  instance_type = var.ec2_instance_type

  subnet_id              = var.subnet_id_private
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_instance_sg.id]

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  key_name = var.keypair
  tags = {
    Name       = "${local.resource_prefix}-instance"
    ssmenabled = var.ssm_env
    app_name   = var.tag_app_name
    env        = var.env_name
  }
  user_data = file("${path.module}/../../modules/config/scripts/ec2_userdata.sh")
}


resource "aws_volume_attachment" "ebsAttach" {
  device_name = "/dev/sdh"
  volume_id   = var.ebs_volume_id
  instance_id = aws_instance.ec2-web.id
}
