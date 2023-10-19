locals {
  workspace_id = var.create_workspace ? aws_prometheus_workspace.this.id : var.workspace_id
}

resource "aws_prometheus_workspace" "this" {

  alias = var.workspace_name
  tags = var.tags
  
  dynamic "logging_configuration" {
    for_each = length(var.logging_configuration) > 0 ? [var.logging_configuration] : []

    content {
      log_group_arn = logging_configuration.value.log_group_arn
    }
  }
}

resource "aws_prometheus_alert_manager_definition" "this" {

  workspace_id = local.workspace_id
  definition   = var.alert_manager_definition
}

resource "aws_prometheus_rule_group_namespace" "this" {
  for_each = {}

  name         = each.value.name
  workspace_id = local.workspace_id
  data         = each.value.data
}