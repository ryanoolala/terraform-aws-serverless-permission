locals {
  group_name                  = "${replace(var.project_name, " ", "-")}-serverless-deployer-group"
  number_of_additional_policy = length(var.additional_policies[0]) > 0 ? length(var.additional_policies) : 0
}

resource "aws_iam_role" "role" {
  name                 = "${var.project_name}-serverless-deployer-role"
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
      "arn:aws:cloudformation:${aws_region}:${var.account_id}:stack/${var.project_name}-${var.application_stage}/*"
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
      "arn:aws:lambda:${var.aws_region}:${var.account_id}:function:${var.project_name}-${var.application_stage}-*"
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
      "arn:aws:events:${var.aws_region}:${var.account_id}:rule/${var.project_name}-${var.application_stage}-${var.aws_region}"
    ]
  }
  statement {
    sid = "12"

    actions = [
      "events:DescribeRule"
    ]

    resources = [
      "arn:aws:events:${var.aws_region}:${var.account_id}:rule/${var.project_name}-${var.application_stage}-*"
    ]
  }
  statement {
    sid = "13"

    actions = [
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
      "arn:aws:iam::${var.account_id}:role/${var.project_name}-${var.application_stage}-${var.aws_region}-lambdaRole"
    ]
  }
  // statement {
  //   actions = [
  //     "s3:*",
  //   ]

  //   resources = [
  //     "arn:aws:s3:::${var.s3_bucket_name}/home/&{aws:username}",
  //     "arn:aws:s3:::${var.s3_bucket_name}/home/&{aws:username}/*",
  //   ]
  // }

  // statement {
  //   actions = [
  //   ]

  //   resources = [
  //   ]

  //   condition {
  //     test     = "StringLike"
  //     variable = "s3:prefix"

  //     values = [
  //       "",
  //       "home/",
  //       "home/&{aws:username}/",
  //     ]
  //   }
  // }
}

// data "aws_iam_policy_document" "example" {
//   statement {
//     sid = "1"

//     actions = [
//       "s3:ListAllMyBuckets",
//       "s3:GetBucketLocation",
//     ]

//     resources = [
//       "arn:aws:s3:::*",
//     ]
//   }
// }