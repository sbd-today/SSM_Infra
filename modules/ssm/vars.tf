variable "project_name" {
  type        = string
  description = "Project name without any spaces"
}


variable "env_name" {
  type        = string
  description = "Environment name"
}
variable "ssmenabled_policy" {
  type        = string
  description = "SSM Policy name"
}
variable "ssm_env" {
  type        = string
  description = "SSM Policy tag environment"
}