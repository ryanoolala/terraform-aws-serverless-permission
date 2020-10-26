locals {
  group_name = "${replace(var.project_name, " ", "-")}-serverless-deployer-group"

  s3_arns = [
    for s3_name in compact(var.s3_bucket_names) :
    "arn:aws:s3:::${s3_name}"
  ]

  dynamodb_table_arns = [
    for table_name in compact(var.dynamodb_table_names) :
    "arn:aws:dynamodb:*:${var.account_id}:table/${table_name}"
  ]

  kinesis_stream_arns = [
    for stream_name in compact(var.kinesis_stream_names) :
    "arn:aws:kinesis:*:*:stream/${stream_name}"
  ]

  sns_arns = [
    for sns_name in compact(var.sns_topic_names) :
    "arn:aws:sns:${var.aws_region}:${var.account_id}:${sns_name}"
  ]

  sqs_arns = [
    for sqs_name in compact(var.sqs_names) :
    "arn:aws:sqs:*:${sqs_name}"
  ]

  elb_arns = concat([
    for elb_name in compact(var.elb_names) :
    "arn:aws:elasticloadbalancing:${var.aws_region}:${var.account_id}:*/${elb_name}"
    ],
    [
      for elb_name in compact(var.elb_names) :
    "arn:aws:elasticloadbalancing:${var.aws_region}:${var.account_id}:*/${elb_name}/*"]
  )
}