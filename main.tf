resource "aws_iam_user" "iam_user" {
  for_each             = var.users
  name                 = each.value.username
  force_destroy        = true
  permissions_boundary = each.value.permissions_boundary

  tags = {
    applied_with = "terraform"
    name         = each.value.name
    description  = each.value.description
    module_url   = "https://github.com/ryanoolala/terraform-aws-serverless-permission"
  }
}

resource "aws_iam_access_key" "access_key" {
  depends_on = [
    aws_iam_user.iam_user
  ]
  for_each = var.users

  user    = each.value.username
  pgp_key = each.value.pgp_key
}