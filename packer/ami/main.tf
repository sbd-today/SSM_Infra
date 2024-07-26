resource "null_resource" "ec2-ami" {
  provisioner "local-exec" {
    command = "packer init  ${path.module}/ubuntu-ami.pkr.hcl && packer build -force ${path.module}/ubuntu-ami.pkr.hcl"
  }
}

 