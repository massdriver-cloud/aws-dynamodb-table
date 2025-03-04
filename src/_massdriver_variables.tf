// Auto-generated variable declarations from massdriver.yaml
variable "authentication" {
  type = object({
    data = object({
      arn         = string
      external_id = optional(string)
    })
    specs = object({
      aws = optional(object({
        region = optional(string)
      }))
    })
  })
}
variable "capacity" {
  type = object({
    billing_mode   = optional(string)
    read_capacity  = optional(number)
    write_capacity = optional(number)
  })
  default = null
}
variable "global_secondary_indexes" {
  type = list(object({
    attributes      = optional(any)
    name            = string
    projection_type = string
    read_capacity   = number
    write_capacity  = number
  }))
  default = null
}
variable "md_metadata" {
  type = object({
    default_tags = object({
      managed-by  = string
      md-manifest = string
      md-package  = string
      md-project  = string
      md-target   = string
    })
    deployment = object({
      id = string
    })
    name_prefix = string
    observability = object({
      alarm_webhook_url = string
    })
    package = object({
      created_at             = string
      deployment_enqueued_at = string
      previous_status        = string
      updated_at             = string
    })
    target = object({
      contact_email = string
    })
  })
}
variable "primary_index" {
  type = object({
    type               = optional(string)
    partition_key      = optional(string)
    partition_key_type = optional(string)
    sort_key           = optional(string)
    sort_key_type      = optional(string)
  })
  default = null
}
variable "region" {
  type = string
}
variable "stream" {
  type = object({
    enabled   = optional(bool)
    view_type = optional(string)
  })
  default = null
}
variable "ttl" {
  type = object({
    enabled = optional(bool)
  })
  default = null
}
// Auto-generated variable declarations from massdriver.yaml
variable "pitr" {
  type = object({
    enabled = optional(bool)
  })
  default = null
}
