/* User creation */
variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "users" {
  description = "A map users to create"
  type = map(object({
    description          = string
    name                 = string
    permissions_boundary = string
    username             = string
    pgp_key              = string
  }))
  default = {}

  /* Example
    users = {
      description = ""
      name = "Firstname Lastname"
      permissions_boundary = ""
      username = "default-username"
      pgp_key = ""
    }
  */
}

variable "project_name" {
  description = "Serverless project name"
  type        = string
}

variable "additional_policies" {
  description = "Additional policy arns to attach to the group"
  type        = list(string)
  default     = []
}

variable "permissions_boundary" {
  description = "If provided, all IAM roles will be created with this permissions boundary attached."
  type        = string
  default     = ""
}

variable "account_id" {
  description = "AWS account id where this serverless deployment will create cloudformation resources etc"
  type        = number
}

variable "application_stage" {
  description = "Stage of this serverless application"
  type        = string
  default     = "staging"
}

variable "enable_api_gateway" {
  description = "Create iam policy for deploying api gateway resources"
  type        = bool
  default     = false
}

variable "enable_ec2" {
  description = "Create iam policy for deploying ec2 resources"
  type        = bool
  default     = false
}

variable "dynamodb_table_names" {
  description = "List of dynamodb tables resources to manage"
  type        = list(string)
  default     = []
}

variable "kinesis_stream_names" {
  description = "List of kinesis stream resources to manage"
  type        = list(string)
  default     = []
}

variable "s3_bucket_names" {
  description = "List of custom s3 bucket names"
  type        = list(string)
  default     = []
}

variable "sns_topic_names" {
  description = "List of sns resources to manage"
  type        = list(string)
  default     = []
}

variable "sqs_names" {
  description = "List of sqs resources to manage"
  type        = list(string)
  default     = []
}

variable "elb_names" {
  description = "List of elb resources to manage"
  type        = list(string)
  default     = []
}