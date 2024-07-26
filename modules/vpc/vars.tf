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

variable "prisub1cidr" {
  type = string
}

variable "prisub2cidr" {
  type = string
}

variable "prisub3cidr" {
  type = string
}

variable "pubsub1cidr" {
  type = string
}

variable "pubsub2cidr" {
  type = string
}

variable "pubsub3cidr" {
  type = string
}
variable "region" {
  type = string
}
variable "reuse_loggroup" {
  type = bool
}