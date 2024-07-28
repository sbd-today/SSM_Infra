output "va_endpoint_domain" {
  description = "AWS generated domain for Verified access endpoint"
  value       = try(aws_verifiedaccess_endpoint.va_endpoint[0].endpoint_domain, null)
}