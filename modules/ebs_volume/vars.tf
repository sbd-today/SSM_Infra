variable "project_name" {
  type        = string
  description = "Project name without any spaces"
}


variable "env_name" {
  type        = string
  description = "Environment name"
}


variable "region" {
  type = string
}

variable "size" {
  type = number
}

variable "type" {
  type = string
}
