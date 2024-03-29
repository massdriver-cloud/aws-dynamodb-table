locals {
  period = "60"
}

module "alarm_channel" {
  source      = "github.com/massdriver-cloud/terraform-modules//aws/alarm-channel?ref=b3f3449"
  md_metadata = var.md_metadata
}

resource "aws_cloudwatch_metric_alarm" "read_capacity" {
  count               = var.capacity.billing_mode == "PROVISIONED" ? 1 : 0
  depends_on          = [aws_dynamodb_table.main]
  alarm_name          = "${local.name}: Read Capacity Usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = "80"
  alarm_description   = "Total read capacity consumption of Dynamodb table ${local.name} is above 80%. Increase the capacity to avoid throttling."
  actions_enabled     = "true"
  alarm_actions       = [module.alarm_channel.arn]
  ok_actions          = [module.alarm_channel.arn]

  metric_query {
    id          = "m3"
    expression  = "(m1 / (m2 * ${local.period})) * 100"
    label       = "Read Capacity Consumed"
    return_data = true
  }

  metric_query {
    # Total Used Capcity
    id = "m1"

    metric {
      metric_name = "ConsumedReadCapacityUnits"
      namespace   = "AWS/DynamoDB"
      period      = local.period
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
      period      = local.period
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
  alarm_description   = "Total Write capacity consumption of Dynamodb table ${local.name} is above 80%. Increase the capacity to avoid throttling."
  actions_enabled     = "true"
  alarm_actions       = [module.alarm_channel.arn]
  ok_actions          = [module.alarm_channel.arn]

  metric_query {
    id          = "m3"
    expression  = "(m1 / (m2 * ${local.period})) * 100"
    label       = "Read Capacity Consumed"
    return_data = true
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "ConsumedWriteCapacityUnits"
      namespace   = "AWS/DynamoDB"
      period      = local.period
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
      period      = local.period
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

module "gsi_write_capacity" {
  for_each            = local.global_secondary_indexes
  source              = "github.com/massdriver-cloud/terraform-modules//aws/cloudwatch-alarm-expression?ref=29df3b2"
  sns_topic_arn       = module.alarm_channel.arn
  md_metadata         = var.md_metadata
  alarm_name          = "${local.name}-${each.key}: Write Capacity Usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  message             = "Global Secondary Index ${each.key} for table ${local.name}: Write Capcity Consumed > 80%. Increase provisioned write capacity."
  display_name        = "Global Secondary Index ${each.key}: Write Capacity Usage"
  threshold           = "80"
  display_metric_key  = "m1"

  metric_queries = {
    m1 = {
      metric = {
        metric_name = "ConsumedWriteCapacityUnits"
        namespace   = "AWS/DynamoDB"
        period      = local.period
        stat        = "Sum"

        dimensions = {
          TableName                = local.name
          GlobalSecondaryIndexName = each.key
        }
      }
    }

    m2 = {
      metric = {
        metric_name = "ProvisionedWriteCapacityUnits"
        namespace   = "AWS/DynamoDB"
        period      = local.period
        stat        = "Sum"

        dimensions = {
          TableName                = local.name
          GlobalSecondaryIndexName = each.key
        }
      }
    }

    m3 = {
      expression  = "(m1 / (m2 * ${local.period})) * 100"
      label       = "Write Capacity Consumed"
      return_data = true
    }
  }
}

module "gsi_read_capacity" {
  for_each            = local.global_secondary_indexes
  source              = "github.com/massdriver-cloud/terraform-modules//aws/cloudwatch-alarm-expression?ref=29df3b2"
  sns_topic_arn       = module.alarm_channel.arn
  md_metadata         = var.md_metadata
  alarm_name          = "${local.name}-${each.key}: Read Capacity Usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  message             = "Global Secondary Index ${each.key} for table ${local.name}: Read Capcity Consumed > 80%. Increase provisioned read capacity."
  display_name        = "Global Secondary Index ${each.key}: Read Capacity Usage"
  threshold           = "80"
  display_metric_key  = "m1"

  metric_queries = {
    m1 = {
      metric = {
        metric_name = "ConsumedReadCapacityUnits"
        namespace   = "AWS/DynamoDB"
        period      = local.period
        stat        = "Sum"

        dimensions = {
          TableName                = local.name
          GlobalSecondaryIndexName = each.key
        }
      }
    }

    m2 = {
      metric = {
        metric_name = "ProvisionedReadCapacityUnits"
        namespace   = "AWS/DynamoDB"
        period      = local.period
        stat        = "Sum"

        dimensions = {
          TableName                = local.name
          GlobalSecondaryIndexName = each.key
        }
      }
    }

    m3 = {
      expression  = "(m1 / (m2 * ${local.period})) * 100"
      label       = "Read Capacity Consumed"
      return_data = true
    }
  }
}
