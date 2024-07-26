#VPC output vlaue reference https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/outputs.tf

output "vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.main.id, null)
}

output "vpc_arn" {
  description = "VPC's ARN"
  value       = try(aws_vpc.main.arn, null)
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = try(aws_vpc.main.cidr_block, null)
}

output "subnet_pub_01" {
  value = try(aws_subnet.vpc_subnet_pub_01.id, null)
}

output "subnet_public_02" {
  value = try(aws_subnet.vpc_subnet_pub_02.id, null)
}

output "subnet_public_03" {
  value = try(aws_subnet.vpc_subnet_pub_03.id, null)
}


output "subnet_private_01" {
  value = try(aws_subnet.vpc_subnet_priv_01.id, null)
}

output "subnet_private_02" {
  value = try(aws_subnet.vpc_subnet_priv_02.id, null)
}