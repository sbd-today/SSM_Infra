locals {
  tags = merge(var. tags, {
    Name : var.svc_name
  })
}

resource "aws_verifiedaccess_instance" "va_instance" {
  count = var.enable_va ? 1 : 0
  tags = local.tags
  depends_on = [ aws_verifiedaccess_trust_provider.va_user_trust_provider ]
}

resource "aws_verifiedaccess_trust_provider" "va_user_trust_provider" {
  count = var.enable_va && var.va_trustprovider_id == null ? 1 : 0

  description = format("Verified Access Trust provider for %s app", var.svc_name)

  policy_reference_name    = replace(format("%s-%s", var.env_abbr, var.svc_name), "-", "_")
  trust_provider_type      = "user"
  user_trust_provider_type = var.va_user_trust_provider_type

  dynamic "oidc_options" {
    for_each = var.va_user_trust_provider_type == "oidc" ? [1] : []
    content {
      authorization_endpoint = var.va_authorization_endpoint
      client_id              = var.va_client_id
      client_secret          = var.va_client_secret
      issuer                 = var.va_issuer
      scope                  = var.va_scope
      token_endpoint         = var.va_token_endpoint
      user_info_endpoint     = var.va_user_info_endpoint
    }
  }

  tags = local.tags
}

resource "aws_verifiedaccess_instance_trust_provider_attachment" "va_intstance_trust_attachment" {
  count = var.enable_va ? 1 : 0
  verifiedaccess_instance_id       = aws_verifiedaccess_instance.va_instance[0].id
  verifiedaccess_trust_provider_id = var.va_trustprovider_id == null ? aws_verifiedaccess_trust_provider.va_user_trust_provider[0].id : var.va_trustprovider_id
}

resource "aws_verifiedaccess_group" "va_group" {
  count = var.enable_va ? 1 : 0

  verifiedaccess_instance_id = aws_verifiedaccess_instance.va_instance[0].id
  policy_document            = var.va_group_policy_document

  tags = local.tags

  depends_on = [
    aws_verifiedaccess_instance_trust_provider_attachment.va_intstance_trust_attachment[0]
  ]
}

resource "aws_verifiedaccess_endpoint" "va_endpoint" {
  count = var.enable_va ? 1 : 0

  application_domain     = var.app_domain
  attachment_type        = "vpc"
  domain_certificate_arn = var.va_domain_cert_arn
  endpoint_domain_prefix = substr(format("%s-%s", var.env_abbr, var.svc_name), 0, 19)
  endpoint_type          = var.va_endpoint_type
  dynamic network_interface_options {
    for_each = var.va_endpoint_type=="network-interface" ? [1] : []
    content {
        network_interface_id = var.network_interface_id
        port                 = var.network_interface_port
        protocol             = var.network_interface_protocol
    }
  }
  # endpoint_type          = "load-balancer"
  dynamic load_balancer_options {
    for_each = var.va_user_trust_provider_type=="load-balancer" ? [1] : []
    content {
        load_balancer_arn = var.lb_arn
        port              = var.lb_port
        protocol          = var.lb_protocol
        subnet_ids        = var.subnet_ids
    }
  }
  security_group_ids       = var.sg_ids
  verified_access_group_id = aws_verifiedaccess_group.va_group[0].id
}

resource "aws_verifiedaccess_instance_logging_configuration" "va_instance_logging" {
  count = var.enable_va && var.enable_va_logging ? 1 : 0

  verifiedaccess_instance_id = aws_verifiedaccess_instance.va_instance[0].id

  access_logs {
    include_trust_context = var.va_log_include_trust_context
    log_version           = var.va_log_version


    dynamic "cloudwatch_logs" {
      for_each = var.va_log_cloudwatch_enabled ? [1] : []
      content {
        enabled   = var.va_log_cloudwatch_enabled
        log_group = var.va_log_cloudwatch_log_group_id
      }
    }

    dynamic "kinesis_data_firehose" {
      for_each = var.va_log_kinesis_enabled ? [1] : []
      content {
        enabled         = var.va_log_kinesis_enabled
        delivery_stream = var.va_log_kinesis_delivery_stream_name

      }
    }

    dynamic "s3" {
      for_each = var.va_log_s3_enabled ? [1] : []
      content {
        enabled     = var.va_log_s3_enabled
        bucket_name = var.va_log_s3_bucket_name

      }
    }
  }
}