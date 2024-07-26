data "aws_availability_zones" "available_zones" {
  state = "available"
  filter {
    name   = "region-name"
    values = ["${var.region}"]
  }
}

resource "aws_ebs_volume" "volume" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  size              = var.size
  type              = var.type

  tags = {
    App  = "${var.project_name}"
    Type = "EBS volume"
    Env  = "${var.env_name}"
  }

}