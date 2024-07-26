resource "aws_iam_role" "role" {
  name = "${var.project_name}-${var.env_name}-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project_name}-${var.env_name}-instance-profile"
  role = aws_iam_role.role.name
}


resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = data.aws_iam_policy.SSMQuickSetupPolicy.arn
}


data "aws_iam_policy" "SSMQuickSetupPolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_policy_cloudwatch_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = var.instance_ssm_cloudwatch_arn
}




resource "aws_iam_policy" "custom_policy" {
  name        = "${var.project_name}-${var.env_name}-custom-policies-assume-role"
  path        = "/"
  description = "Access to secrets manager"
  policy      = data.aws_iam_policy_document.ec2_custom_policies.json
}


resource "aws_iam_role_policy_attachment" "ec2_custome_policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.custom_policy.arn
}

data "aws_iam_policy_document" "ec2_custom_policies" {
  statement {

    effect = "Allow"

    actions = [
      "secretsmanager:ListSecrets",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetRandomPassword",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:TagResource",
      "secretsmanager:UntagResource",
      "ssm:GetDocument",
      "ssm:GetInventory",
      "ssm:ListDocuments",
      "ssm:ListCommands",
      "ssm:ListAssociations",
      "s3:HeadBucket",
      "s3:GetBucketPolicy",
      "s3:GetBucketPolicyStatus",
      "s3:GetBucketAcl",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "ec2:DescribeInstances",
    ]

    resources = [
      "*"
    ]
  }
}