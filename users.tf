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

resource "aws_iam_group" "group" {
  count = length(var.users) > 0 ? 1 : 0
  depends_on = [
    aws_iam_user.iam_user
  ]
  name = local.group_name
}

// resource "aws_iam_group_policy" "serverless_policy" {
//   depends_on = [
//     aws_iam_user.iam_user
//   ]
//   name  = "${local.group_name}-policy"
//   group = aws_iam_group.group[0].name

//   policy = aws_iam_policy.serverless_policy
// }

resource "aws_iam_group_policy_attachment" "attachment" {
  count      = length(var.users) > 0 ? length(compact(var.additional_policies)) : 0
  group      = aws_iam_group.group[0].name
  policy_arn = var.additional_policies[count.index]
}

resource "aws_iam_group_membership" "group" {
  name  = "${local.group_name}-membership"
  users = values(var.users)[*].username
  group = aws_iam_group.group[0].name
}