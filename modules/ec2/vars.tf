variable "project_name" {
  type        = string
  description = "Project name without any spaces"
}


variable "env_name" {
  type        = string
  description = "Environment name"
}

variable "cidr_block" {
  type        = string
  description = "VPC CIDR Block"
}

variable "vpc_id" {
  type = string
}


variable "subnet_id_public_01" {
  type = string
}

variable "subnet_id_public_02" {
  type = string
}

variable "subnet_id_public_03" {
  type = string
}

variable "ec2_instance_type" {

}

variable "ssm_env" {
  type = string
}
locals {
  resource_prefix = "${var.project_name}-${var.env_name}"
}


variable "keypair" {
  type = string
}

variable "ssh_secret_store" {
  type = string
}

variable "require_alb" {
  type = bool
}

variable "ebs_volume_id" {
  type = string
}
variable "instance_ssm_cloudwatch_arn" {
  type = string
}

variable "certificate_arn" {
  type = string
}


variable "subnet_id_private" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "tag_app_name" {
  type = string
}
