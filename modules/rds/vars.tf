variable "project_name" {
  type        = string
  description = "Project name without any spaces"
}


variable "env_name" {
  type        = string
  description = "Environment name"
}

variable "ec2_instance_sg_id" {
  type = string
}

variable "dbsubnet_01" {
  type = string
}

variable "dbsubnet_02" {
  type = string
}


variable "vpc_id" {
  type = string
}

variable "rds_snapshot_identifier" {
  type = string
}

variable "tagname" {
  type = string
}

