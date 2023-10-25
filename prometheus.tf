data "aws_region" "current" {}

locals {
  workspace_id = var.create_workspace ? aws_prometheus_workspace.this.id : var.workspace_id
  name     = "aws-observability-accelerator-cloudwatch"
  # amp_list = toset(split(",", var.managed_prometheus_workspace_ids))
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

resource "grafana_folder" "data_source_dashboards" {
  title = "test folder data_source_dashboards"
}

resource "grafana_dashboard" "metrics" {
  config_json = file("grafana-dashboard.json")
}

resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = var.workspace_name

  # Giving priority to Managed Prometheus datasources
  is_default = false
  json_data_encoded = jsonencode({
    default_region  = var.aws_region
    sigv4_auth      = true
    sigv4_auth_type = "workspace-iam-role"
    sigv4_region    = var.aws_region
  })
}