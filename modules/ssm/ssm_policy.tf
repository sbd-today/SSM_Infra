resource "aws_iam_policy" "ssm_policy" {
  name        = var.ssmenabled_policy
  path        = "/"
  description = "Access to SSM"
  policy      = data.aws_iam_policy_document.ssm_policy_doc.json
}

data "aws_iam_policy_document" "ssm_policy_doc" {
  # statement {

  #   sid    = "EnableSSMSessionDescription"
  #   effect = "Allow"

  #   actions = [
  #     "ssm:DescribeSessions",
  #     "ssm:DescribeInstanceInformation",
  #     "ssm:SendCommand",
  #     "ssm:GetConnectionStatus"
  #   ]

  #   resources = [
  #     "*"
  #   ]
  # }
  statement {

    sid    = "EnableSSMSession"
    effect = "Allow"

    actions = [
      "ssm:StartSession",
      "ssm:TerminateSession"
    ]

    resources = [
      "*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/ssmenabled"

      values = [var.ssm_env]
    }
  }
  statement {

    sid    = "EnableSSMSessionCommands"
    effect = "Allow"

    actions = [
      "ssm:SendCommand",
      "ssm:StartSession"
    ]

    resources = [
      "arn:aws:ssm:*:*:document/*"
    ]
  }
}
resource "aws_iam_policy" "instance_cloudwatch_policy" {
  name        = "${var.project_name}-${var.env_name}-cloudwatch-policy"
  path        = "/"
  description = "Policy for allowing push of ssm logs to cloudwatch"
  policy      = data.aws_iam_policy_document.ssm_cloudwatch_policy_doc.json
}

data "aws_iam_policy_document" "ssm_cloudwatch_policy_doc" {
  statement {

    sid    = "CloudWatchSSMLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]

    resources = [
      "*"
    ]
  }
}
