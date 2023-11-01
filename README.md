# acp-aws-prometheus-tf
Terraform module for Amazon Managed Prometheus
The purpose of this Terraform module is to create AWS managed Prometheus resources i.e. workspaces, alert manager, rule group namespaces.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_prometheus_alert_manager_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_alert_manager_definition) | resource |
| [aws_prometheus_rule_group_namespace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_rule_group_namespace) | resource |
| [aws_prometheus_workspace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_workspace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_manager_definition"></a> [alert\_manager\_definition](#input\_alert\_manager\_definition) | The alert manager definition that you want to be applied. See more in the [AWS Docs](https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-alert-manager.html) | `string` | `"alertmanager_config: |\n  route:\n    receiver: 'default'\n  receivers:\n    - name: 'default'\n"` | no |
| <a name="input_create_workspace"></a> [create\_workspace](#input\_create\_workspace) | Determines whether a workspace will be created or to use an existing workspace | `bool` | `true` | no |
| <a name="input_logging_configuration"></a> [logging\_configuration](#input\_logging\_configuration) | The logging configuration of the prometheus workspace. | `map(string)` | `{}` | no |
| <a name="input_rule_group_namespaces"></a> [rule\_group\_namespaces](#input\_rule\_group\_namespaces) | A map of one or more rule group namespace definitions | `map(any)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_workspace_alias"></a> [workspace\_alias](#input\_workspace\_alias) | The alias of the prometheus workspace. See more in the [AWS Docs](https://docs.aws.amazon.com/prometheus/latest/userguide/AMP-onboard-create-workspace.html) | `string` | `null` | no |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | The ID of an existing workspace to use when `create_workspace` is `false` | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace_arn"></a> [workspace\_arn](#output\_workspace\_arn) | Amazon Resource Name (ARN) of the workspace |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | Identifier of the workspace |
| <a name="output_workspace_prometheus_endpoint"></a> [workspace\_prometheus\_endpoint](#output\_workspace\_prometheus\_endpoint) | Prometheus endpoint available for this workspace |

## Example

```
module "prometheus-workspace" {
  source = "git::https://github.com/UKHomeOffice/acp-aws-prometheus-tf?ref=v1"
  workspace_alias = "myawesome_workspace"

  alert_manager_definition = <<-EOT
  alertmanager_config: |
    route:
      receiver: 'default'
    receivers:
      - name: 'default'
  EOT

  rule_group_namespaces = {
    first = {
      name = "rule-01"
      data = <<-EOT
      groups:
        - name: test
          rules:
          - record: metric:recording_rule
            expr: avg(rate(container_cpu_usage_seconds_total[5m]))
      EOT
    }
    second = {
      name = "rule-02"
      data = <<-EOT
      groups:
        - name: test
          rules:
          - record: metric:recording_rule
            expr: avg(rate(container_cpu_usage_seconds_total[5m]))
      EOT
    }
  }
}
```