output "access_key" {
  description = "base64-encoded, encrypted access key of the user, use `base64 -d` to decrypt and `gpg -d encrypted.txt`"
  value       = aws_iam_access_key.access_key
}

output "users" {
  description = "IAM Users"
  value       = aws_iam_user.iam_user
}

output "policy_json" {
  description = "IAM Policy created for this module"
  value       = aws_iam_policy.policy.policy
}

output "role_arn" {
  description = "ARN of the role created"
  value       = aws_iam_role.role.arn
}

output "group_arn" {
  description = "IAM group ARN that contains the users created by this module"
  value       = aws_iam_group.group[0].arn
}

output "group_membership" {
  description = "List of users in the group"
  value       = aws_iam_group_membership.group.users
}