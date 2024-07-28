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


variable "vpccidr" {
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

variable "prisub1cidr" {
  type = string
}

variable "prisub2cidr" {
  type = string
}

variable "prisub3cidr" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}


variable "bucket_name" {
  type        = string
  description = "S3 bucket"
}


variable "ssmenabled_policy" {
  type = string
}
variable "ssm_env" {
  type = string
}

variable "email_addresses" {
  type = list(string)
}

variable "rds_snapshot_identifier" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "require_alb" {
  type = string
}

variable "reuse_SSM_log_group" {
  type = bool
}

variable "ebs_volume_type" {
  type    = string
  default = "gp3"
}

variable "ebs_volumes_size" {
  type    = number
  default = 40

}

variable "ec2_ami_id" {
  type = string
}
variable "tag_app_name" {
  type = string
}
variable "db_tag_app_name" {
  type = string
}

variable "app_domain" {
  type = string
}

variable "va_domain_cert_arn" {
  type = string
}

# variable "va_policy" {
#   type = string
#   nullable = false
  
# }