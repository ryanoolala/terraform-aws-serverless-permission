locals {
  group_name = "${replace(var.project_name, " ", "-")}-serverless-deployer-group"
  number_of_additional_policy = length(var.additional_policies[0]) > 0 ? length(var.additional_policies) : 0
}

resource "aws_iam_role" "role" {
  name = "${var.project_name}-serverless-deployer-role"
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