#
# Common variables
#
variable "svc_name" {
  type    = string
  default = "bloginstance"
}
variable "env_abbr" {
  type    = string
  default = "dev"
}
variable "tags" {
  default = {
    automation : "terraform"
    data_classification : "internal"
  }
}

#
# Network
#
variable "subnet_ids" {
  description = "A list of subnet ids where verified access endpoint will be placed. Only useful for load balancer"
  type        = list(string)
  default     =[]
}
variable "sg_ids" {
  description = "List of the the security groups IDs to associate with the Verified Access endpoint"
  type        = list(string)
}
variable "lb_arn" {
  description = "The ARN of the load balancer that will be used for the Verified Access endpoint. Only useful for load balancer"
  type        = string
  default     = ""
}
variable "lb_port" {
  description = "The load balancer port that will be used for the Verified Access endpoint"
  type        = string
  default     = 8080
}
variable "lb_protocol" {
  description = "The load balancer protocol that will be used for the Verified Access endpoint"
  type        = string
  default     = "http"
}

#
# Verified Access Common
#
variable "enable_va" {
  default = true
}
variable "enable_va_logging" {
  default = true
}
variable "va_domain_cert_arn" {
  nullable = false
}
variable "va_group_policy_document" {
  description = "The policy document that is associated with this resource"
  type        = string
  nullable = false
}

#
# Verified Access Trust provider
#
variable "va_trustprovider_id" {
  default = null
}
variable "va_user_trust_provider_type" {
  description = "The type of user-based trust provider."
  type        = string
  default     = "iam-identity-center"
}

#
# Verified Access logging
#
variable "va_log_include_trust_context" {
  default = true
}
variable "va_log_version" {
  default = "ocsf-1.0.0-rc.2"
}

variable "va_log_cloudwatch_enabled" {
  default = false
}
variable "va_log_cloudwatch_log_group_id" {
  default = ""
}

variable "va_log_kinesis_enabled" {
  default = false
}

variable "va_log_kinesis_delivery_stream_name" {
  default = null
}

variable "va_log_s3_enabled" {
  default = false
}
variable "va_log_s3_bucket_name" {
  default = null
}

#
# Verified Access Trust provider OIDC Settings
#
variable "va_authorization_endpoint" {
  description = "The OIDC authorization endpoint"
  type        = string
  default     = "https://accounts.google.com/o/oauth2/v2/auth"
}
variable "va_client_id" {
  description = "The client identifier"
  type        = string
  default = ""
}
variable "va_client_secret" {
  description = "The client secret"
  type        = string
  default = ""
}
variable "va_issuer" {
  description = "The OIDC issuer"
  type        = string
  default     = "https://accounts.google.com"
}
variable "va_scope" {
  description = "OpenID Connect (OIDC) scopes are used by an application during authentication to authorize access to details of a user."
  type        = string
  default     = "openid email profile"
}
variable "va_token_endpoint" {
  description = "The OIDC token endpoint"
  type        = string
  default     = "https://oauth2.googleapis.com/token"
}
variable "va_user_info_endpoint" {
  description = "The OIDC user info endpoint"
  type        = string
  default     = "https://openidconnect.googleapis.com/v1/userinfo"
}

variable "app_domain" {
  description = "The application domain of the application"
  type        = string
  nullable = false
}

variable "va_endpoint_type" {
  description = "The endpoint type as supported by verified access endpoint type resource"
  type        = string
  default = "network-interface"
}
variable "network_interface_id" {
  description   = "The ENI interface Id of the network resource"
  type          = string
}
variable "network_interface_port" {
  description   = "The port on whichh the application is listening on the network interface"
  type          = number
  default = 80
}
variable "network_interface_protocol" {
  description   = "The protocol on whichh the application is listening on the network interface"
  type          = string
  default       = "http"
}