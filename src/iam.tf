locals {
  read_statement = [{
    Action = [
      "dynamodb:BatchGetItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:GetItem",
      "dynamodb:PartiQLSelect",
      "dynamodb:Query",
      "dynamodb:Scan",

    ]
    Effect   = "Allow"
    Resource = aws_dynamodb_table.main.arn
  }]

  write_statement = [{
    Action = [
      "dynamodb:BatchWriteItem",
      "dynamodb:DeleteItem",
      "dynamodb:PartiQLDelete",
      "dynamodb:PartiQLInsert",
      "dynamodb:PartiQLUpdate",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",

    ]
    Effect   = "Allow"
    Resource = aws_dynamodb_table.main.arn
  }]

  read_stream_statement = [{
    Action = [
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:ListStreams"
    ]
    Effect   = "Allow"
    Resource = aws_dynamodb_table.main.stream_arn
  }]
}

resource "aws_iam_policy" "read" {
  name        = "${local.name}-read"
  description = "AWS Dynamodb read policy: ${local.name}"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.read_statement
  })
}

resource "aws_iam_policy" "write" {
  name        = "${local.name}-write"
  description = "AWS Dynamodb write policy: ${local.name}"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.write_statement
  })
}

resource "aws_iam_policy" "read_stream" {
  count       = var.stream.enabled ? 1 : 0
  name        = "${local.name}-read-stream"
  description = "AWS Dynamodb read policy for attached stream: ${local.name}"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = local.read_stream_statement
  })
}
