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
| account\_id | AWS account id where this serverless deployment will create cloudformation resources etc | `number` | n/a | yes |
| additional\_policies | Additional policy arns to attach to the group | `list(string)` | `[]` | no |
| application\_stage | Stage of this serverless application | `string` | `"staging"` | no |
| aws\_region | aws region | `string` | n/a | yes |
| dynamodb\_table\_names | List of dynamodb tables resources to manage | `list(string)` | `[]` | no |
| elb\_names | List of elb resources to manage | `list(string)` | `[]` | no |
| enable\_api\_gateway | Create iam policy for deploying api gateway resources | `bool` | `false` | no |
| enable\_ec2 | Create iam policy for deploying ec2 resources | `bool` | `false` | no |
| kinesis\_stream\_names | List of kinesis stream resources to manage | `list(string)` | `[]` | no |
| permissions\_boundary | If provided, all IAM roles will be created with this permissions boundary attached. | `string` | `""` | no |
| project\_name | Serverless project name | `string` | n/a | yes |
| s3\_bucket\_names | List of custom s3 bucket names | `list(string)` | `[]` | no |
| sns\_topic\_names | List of sns resources to manage | `list(string)` | `[]` | no |
| sqs\_names | List of sqs resources to manage | `list(string)` | `[]` | no |
| users | A map users to create | <pre>map(object({<br>    description          = string<br>    name                 = string<br>    permissions_boundary = string<br>    username             = string<br>    pgp_key              = string<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_key | base64-encoded, encrypted access key of the user, use `base64 -d` to decrypt and `gpg -d encrypted.txt` |
| group\_arn | IAM group ARN that contains the users created by this module |
| group\_membership | List of users in the group |
| policy\_json | IAM Policy created for this module |
| role\_arn | ARN of the role created |
| users | IAM Users |

