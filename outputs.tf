output "workspace_arn" {
  description = "Resource Name (ARN) of the workspace"
  value       = try(aws_prometheus_workspace.this.arn, "")
}

output "workspace_id" {
  description = "Identifier of the workspace"
  value       = try(aws_prometheus_workspace.this.id, "")
}

output "workspace_prometheus_endpoint" {
  description = "Prometheus endpoint available for this workspace"
  value       = try(aws_prometheus_workspace.this.prometheus_endpoint, "")
}

# output "grafana_dashboard_urls" {
#   value       = [grafana_dashboard.this.url]
#   description = "URLs for dashboards created"
# }