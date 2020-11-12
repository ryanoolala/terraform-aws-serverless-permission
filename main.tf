resource "aws_iam_role" "role" {
  name                 = "serverless-deployer-role-${var.project_name}"
  permissions_boundary = var.permissions_boundary

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

# Only create the custom inline policy for this role if it's not empty
resource "aws_iam_role_policy" "custom_policy" {
  name   = "custom_policy"
  role   = aws_iam_role.role.name
  count  = var.custom_policy != "" ? 1 : 0
  policy = var.custom_policy
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_policy" "policy" {
  name   = "serverless-deployer-policy-${var.project_name}"
  path   = "/"
  policy = data.aws_iam_policy_document.seven.json
}

data "aws_iam_policy_document" "empty" {
}

data "aws_iam_policy_document" "zero" {
  source_json   = data.aws_iam_policy_document.base.json
  override_json = length(local.s3_arns) > 0 ? data.aws_iam_policy_document.s3.json : data.aws_iam_policy_document.empty.json
}

data "aws_iam_policy_document" "one" {
  source_json   = data.aws_iam_policy_document.zero.json
  override_json = var.enable_api_gateway ? data.aws_iam_policy_document.api_gateway.json : data.aws_iam_policy_document.empty.json
}

data "aws_iam_policy_document" "two" {
  source_json   = data.aws_iam_policy_document.one.json
  override_json = var.enable_ec2 ? data.aws_iam_policy_document.ec2.json : data.aws_iam_policy_document.empty.json
}

data "aws_iam_policy_document" "three" {
  source_json   = data.aws_iam_policy_document.two.json
  override_json = length(local.dynamodb_table_arns) > 0 ? data.aws_iam_policy_document.dynamodb.json : data.aws_iam_policy_document.empty.json
}

data "aws_iam_policy_document" "four" {
  source_json   = data.aws_iam_policy_document.three.json
  override_json = length(local.kinesis_stream_arns) > 0 ? data.aws_iam_policy_document.kinesis.json : data.aws_iam_policy_document.empty.json
}

data "aws_iam_policy_document" "five" {
  source_json   = data.aws_iam_policy_document.four.json
  override_json = length(local.sns_arns) > 0 ? data.aws_iam_policy_document.sns.json : data.aws_iam_policy_document.empty.json
}

data "aws_iam_policy_document" "six" {
  source_json   = data.aws_iam_policy_document.five.json
  override_json = length(local.sqs_arns) > 0 ? data.aws_iam_policy_document.sqs.json : data.aws_iam_policy_document.empty.json
}

data "aws_iam_policy_document" "seven" {
  source_json   = data.aws_iam_policy_document.six.json
  override_json = length(local.elb_arns) > 0 ? data.aws_iam_policy_document.elb.json : data.aws_iam_policy_document.empty.json
}

data "aws_iam_policy_document" "base" {
  statement {
    sid = "1"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DeleteLogGroup"
    ]

    resources = [
      "arn:aws:logs:${var.aws_region}:${var.account_id}:*"
    ]
  }

  statement {
    sid = "2"

    actions = [
      "cloudwatch:GetMetricStatistics"
    ]

    resources = ["*"]
  }

  statement {
    sid = "3"

    actions = [
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:FilterLogEvents"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = "4"

    actions = [
      "cloudformation:List*",
      "cloudformation:Get*",
      "cloudformation:ValidateTemplate"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = "5"

    actions = [
      "cloudformation:CreateStack",
      "cloudformation:CreateUploadBucket",
      "cloudformation:DeleteStack",
      "cloudformation:Describe*",
      "cloudformation:UpdateStack"
    ]

    resources = [
      "arn:aws:cloudformation:${var.aws_region}:${var.account_id}:stack/${var.project_name}-${var.application_stage}*/*"
    ]
  }

  statement {
    sid = "6"

    actions = [
      "lambda:Get*",
      "lambda:List*",
      "lambda:CreateFunction"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = "7"

    actions = [
      "s3:GetBucketLocation",
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:ListBucket",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:ListBucketVersions",
      "s3:PutAccelerateConfiguration",
      "s3:GetEncryptionConfiguration",
      "s3:PutEncryptionConfiguration"
    ]

    resources = [
      "arn:aws:s3:::${var.project_name}*serverlessdeploy*"
    ]
  }

  statement {
    sid = "8"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectMetadata",
      "s3:HeadObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${var.project_name}*serverlessdeploy*"
    ]
  }

  statement {
    sid = "9"

    actions = [
      "lambda:AddPermission",
      "lambda:CreateAlias",
      "lambda:DeleteFunction",
      "lambda:InvokeFunction",
      "lambda:PublishVersion",
      "lambda:RemovePermission",
      "lambda:Update*"
    ]

    resources = [
      "arn:aws:lambda:${var.aws_region}:${var.account_id}:function:${var.project_name}-${var.application_stage}*-*"
    ]
  }

  statement {
    sid = "10"

    actions = [
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${var.aws_region}:${var.account_id}:*"
    ]
  }
  statement {
    sid = "11"

    actions = [
      "events:Put*",
      "events:Remove*",
      "events:Delete*"
    ]

    resources = [
      "arn:aws:events:${var.aws_region}:${var.account_id}:rule/${var.project_name}-${var.application_stage}*-${var.aws_region}"
    ]
  }
  statement {
    sid = "12"

    actions = [
      "events:DescribeRule"
    ]

    resources = [
      "arn:aws:events:${var.aws_region}:${var.account_id}:rule/${var.project_name}-${var.application_stage}*-*"
    ]
  }
  statement {
    sid = "13"

    actions = [
      "iam:GetRole",
      "iam:PassRole"
    ]

    resources = [
      "arn:aws:iam::${var.account_id}:role/*"
    ]
  }
  statement {
    sid = "14"

    actions = [
      "iam:GetRole",
      "iam:CreateRole",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:DeleteRole"
    ]

    resources = [
      "arn:aws:iam::${var.account_id}:role/${var.project_name}-*"
    ]
  }
}

data "aws_s3_bucket" "selected" {
  count  = length(compact(var.s3_bucket_names))
  bucket = var.s3_bucket_names[count.index]
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid = "8"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:HeadObject",
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:GetObjectMetadata",
      "s3:ListBucket",
      "s3:GetBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:ListBucketVersions"
    ]

    resources = concat(
      [
        "arn:aws:s3:::${var.project_name}*serverlessdeploy*",
      ],
      local.s3_arns
    )
  }
}

data "aws_iam_policy_document" "api_gateway" {
  statement {
    sid = "15"

    actions = [
      "apigateway:GET",
      "apigateway:POST",
      "apigateway:PUT",
      "apigateway:DELETE",
      "apigateway:PATCH"
    ]

    resources = [
      "arn:aws:apigateway:*::/apis*",
      "arn:aws:apigateway:*::/restapis*",
      "arn:aws:apigateway:*::/apikeys*",
      "arn:aws:apigateway:*::/usageplans*"
    ]
  }
}

data "aws_iam_policy_document" "ec2" {
  statement {
    sid = "16"

    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DescribeDhcpOptions",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterfacePermission",
      "ec2:DeleteNetworkInterface",
      "ec2:createTags",
      "ec2:deleteTags"
    ]

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "dynamodb" {
  statement {
    sid = "17"

    actions = [
      "dynamodb:*"
    ]

    resources = local.dynamodb_table_arns
  }
}

data "aws_iam_policy_document" "kinesis" {
  statement {
    sid = "18"

    actions = [
      "kinesis:*"
    ]

    resources = local.kinesis_stream_arns
  }
}

data "aws_iam_policy_document" "sns" {
  statement {
    sid = "19"

    actions = [
      "sns:*"
    ]

    resources = local.sns_arns
  }
}

data "aws_iam_policy_document" "sqs" {
  statement {
    sid = "20"

    actions = [
      "sqs.*"
    ]

    resources = local.sqs_arns
  }
}

data "aws_iam_policy_document" "elb" {
  statement {
    sid = "21"

    actions = [
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:CreateRule"
    ]

    resources = local.elb_arns
  }
}