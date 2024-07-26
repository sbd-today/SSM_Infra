#VPC output vlaue reference https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/outputs.tf

output "instance_ssm_cloudwatch_arn" {
  value = try(aws_iam_policy.instance_cloudwatch_policy.arn, null)
}