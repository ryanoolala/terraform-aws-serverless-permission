# terraform-aws-serverless-permission

Terraform module to create a serverless deploy limited privilege IAM policy .

base policy and idea came from [https://github.com/Open-SL/serverless-permission-generator](https://github.com/Open-SL/serverless-permission-generator)

This is a terraform implementation for IaC users out there.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | aws region | `string` | n/a | yes |
| users | A map users to create | <pre>map(object({<br>    description          = string<br>    name                 = string<br>    permissions_boundary = string<br>    username             = string<br>    pgp_key              = string<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_key | base64-encoded, encrypted access key of the user, use `base64 -d` to decrypt and `gpg -d encrypted.txt` |
| users | IAM Users |

