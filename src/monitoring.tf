module "alarm_channel" {
  source      = "github.com/massdriver-cloud/terraform-modules//aws-alarm-channel"
  md_metadata = var.md_metadata
}

resource "aws_cloudwatch_metric_alarm" "read_capacity" {
  count               = var.capacity.billing_mode == "PROVISIONED" ? 1 : 0
  depends_on          = [aws_dynamodb_table.main]
  alarm_name          = "${local.name}: Read Capacity Usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = "80"
  alarm_description = jsonencode({
    message = "Total read capacity consumption of Dynamodb table ${local.name} is above 80%. Increase the capacity to avoid throttling."
  })
  actions_enabled = "true"
  alarm_actions   = [module.alarm_channel.arn]
  ok_actions      = [module.alarm_channel.arn]

  metric_query {
    id          = "m3"
    expression  = "m1 / m2"
    label       = "Read Capacity Consumed"
    return_data = true
  }

  metric_query {
    # Total Used Capcity
    id = "m1"

    metric {
      metric_name = "ConsumedReadCapacityUnits"
      namespace   = "AWS/DynamoDB"
      period      = "60"
      stat        = "Sum"

      dimensions = {
        TableName = local.name
      }
    }
  }

  metric_query {
    # Total Provisioned Capacity
    id = "m2"

    metric {
      metric_name = "ProvisionedReadCapacityUnits"
      namespace   = "AWS/DynamoDB"
      period      = "60"
      stat        = "Sum"

      dimensions = {
        TableName = local.name
      }
    }
  }
}

resource "massdriver_package_alarm" "read_capacity" {
  count             = var.capacity.billing_mode == "PROVISIONED" ? 1 : 0
  cloud_resource_id = aws_cloudwatch_metric_alarm.read_capacity[count.index].arn
  display_name      = "DynamoDB Read Capacity Utilization"
}

resource "aws_cloudwatch_metric_alarm" "write_capacity" {
  count               = var.capacity.billing_mode == "PROVISIONED" ? 1 : 0
  depends_on          = [aws_dynamodb_table.main]
  alarm_name          = "${local.name}: Write Capacity Usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = "80"
  alarm_description = jsonencode({
    message = "Total Write capacity consumption of Dynamodb table ${local.name} is above 80%. Increase the capacity to avoid throttling."
  })
  actions_enabled = "true"
  alarm_actions   = [module.alarm_channel.arn]
  ok_actions      = [module.alarm_channel.arn]

  metric_query {
    id          = "m3"
    expression  = "(m1 / m2) * 100"
    label       = "Read Capacity Consumed"
    return_data = true
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "ConsumedWriteCapacityUnits"
      namespace   = "AWS/DynamoDB"
      period      = "60"
      stat        = "Sum"

      dimensions = {
        TableName = local.name
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "ProvisionedWriteCapacityUnits"
      namespace   = "AWS/DynamoDB"
      period      = "60"
      stat        = "Sum"

      dimensions = {
        TableName = local.name
      }
    }
  }
}

resource "massdriver_package_alarm" "write_capacity" {
  count             = var.capacity.billing_mode == "PROVISIONED" ? 1 : 0
  cloud_resource_id = aws_cloudwatch_metric_alarm.write_capacity[count.index].arn
  display_name      = "DynamoDB Write Capacity Utilization"
}
