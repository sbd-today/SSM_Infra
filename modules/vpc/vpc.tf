
locals {
  resource_prefix = "${var.project_name}-${var.env_name}"
}


resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${local.resource_prefix}-vpc"
  }
}



# Subnets
resource "aws_subnet" "vpc_subnet_pub_01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pubsub1cidr
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2a"

  tags = {
    Name = "${local.resource_prefix}-public-subnet-1"
  }
}

resource "aws_subnet" "vpc_subnet_pub_02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pubsub2cidr
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2b"

  tags = {
    Name = "${local.resource_prefix}-public-subnet-2"
  }
}

resource "aws_subnet" "vpc_subnet_pub_03" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pubsub3cidr
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2b"

  tags = {
    Name = "${local.resource_prefix}-public-subnet-3"
  }
}


resource "aws_subnet" "vpc_subnet_priv_01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.prisub1cidr
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2a"

  tags = {
    Name = "${local.resource_prefix}-private-subnet-1"
  }
}

resource "aws_subnet" "vpc_subnet_priv_02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.prisub2cidr
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2b"

  tags = {
    Name = "${local.resource_prefix}-private-subnet-2"
  }
}

resource "aws_subnet" "vpc_subnet_priv_03" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.prisub3cidr
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2b"

  tags = {
    Name = "${local.resource_prefix}-private-subnet-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.resource_prefix}-gw-main"
  }
}

# route tables
resource "aws_route_table" "main-rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }

  tags = {
    Name = "${local.resource_prefix}-public-route-table"
  }
}

# route associations public
resource "aws_route_table_association" "vpc_subnet_pub_01-a" {
  subnet_id      = aws_subnet.vpc_subnet_pub_01.id
  route_table_id = aws_route_table.main-rt.id
}

resource "aws_route_table_association" "vpc_subnet_pub_02-a" {
  subnet_id      = aws_subnet.vpc_subnet_pub_02.id
  route_table_id = aws_route_table.main-rt.id
}

resource "aws_kms_key" "session_log_manager_key" {
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  description              = "SessionManagerKMSKey"
  enable_key_rotation      = false
  key_usage                = "ENCRYPT_DECRYPT"
  multi_region             = false

}



resource "aws_cloudwatch_log_group" "sessionmanager_log_group" {
  count             = var.reuse_loggroup == true ? 0 : 1
  kms_key_id        = aws_kms_key.session_log_manager_key.arn
  log_group_class   = "STANDARD"
  name              = "SSM_SessionManagerLogGroup"
  retention_in_days = 90
  # The following line will ensure that the log group will not get destroyed un intentionally. It would need to be manualy deleted
  skip_destroy = true
  depends_on   = [aws_kms_key_policy.session_log_manager_key_policy]
}

data "aws_caller_identity" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_kms_key_policy" "session_log_manager_key_policy" {
  key_id = aws_kms_key.session_log_manager_key.id
  # depends_on = [ aws_cloudwatch_log_group.sessionmanager_log_group ]
  policy = jsonencode(
    {
      Id = "session-manager-key-policy"
      Statement = [
        {
          Action = "kms:*"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${local.account_id}:root"
          }
          Resource = "*"
          Sid      = "Enable IAM User Permissions"
        },
        {
          Action = [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*",
          ]
          Condition = {
            ArnEquals = {
              "kms:EncryptionContext:aws:logs:arn" = "arn:aws:logs:${var.region}:${local.account_id}:log-group:SSM_SessionManagerLogGroup"
            }
          }
          Effect = "Allow"
          Principal = {
            Service = "logs.${var.region}.amazonaws.com"
          }
          Resource = "*"
        }
      ]
      Version = "2012-10-17"
    }
  )
}