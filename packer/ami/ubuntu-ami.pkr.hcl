packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "nginix-ubuntu" {
  ami_name      = "nginix-ubuntu-base-{{timestamp}}"
  instance_type = "t2.small"
  region        = "us-west-2"
  
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}


build {

  sources = ["source.amazon-ebs.nginix-ubuntu"]

  provisioner "file" {
  source = "config/config.json"
  destination = "/tmp/cloudwatch-config.json"
}

  provisioner "file" {
  source = "config/usr.sbin.nginx"
  destination = "/tmp/usr.sbin.nginx"
}

provisioner "file" {
  source = "config/custom.rules"
  destination = "/tmp/custom.rules"
}

  provisioner "file" {
  source = "config/logrotate.conf"
  destination = "/tmp/logrotate.conf"
}

  provisioner "file" {
  source = "config/audited.conf"
  destination = "/tmp/audited.conf"
}

provisioner "file" {
  source = "config/nginx.conf"
  destination = "/tmp/nginx.conf"
}

   provisioner "shell" {
    script = "./init.sh"
  }
}

