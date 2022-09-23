locals {
  read_capacity    = var.capacity.billing_mode == "PROVISIONED" ? var.capacity.read_capacity : null
  write_capacity   = var.capacity.billing_mode == "PROVISIONED" ? var.capacity.write_capacity : null
  range_key        = var.primary_index.type == "compound" ? var.primary_index.sort_key : null
  sort_key         = var.primary_index.type == "compound" ? [1] : []
  stream_view_type = var.stream.enabled ? var.stream.view_type : null
  name             = var.md_metadata.name_prefix
}
resource "aws_dynamodb_table" "main" {
  name             = local.name
  billing_mode     = var.capacity.billing_mode
  read_capacity    = local.read_capacity
  write_capacity   = local.write_capacity
  hash_key         = var.primary_index.partition_key
  range_key        = local.range_key
  stream_enabled   = var.stream.enabled
  stream_view_type = local.stream_view_type

  attribute {
    name = var.primary_index.partition_key
    type = var.primary_index.partition_key_type
  }

  dynamic "attribute" {
    for_each = var.primary_index.type == "compound" ? [1] : []
    content {
      name = var.primary_index.sort_key
      type = var.primary_index.sort_key_type
    }
  }

  ttl {
    attribute_name = "TTL"
    enabled        = var.ttl.enabled
  }
}
