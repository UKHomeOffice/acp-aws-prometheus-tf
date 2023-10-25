variable "create_workspace" {
  description = "Determines whether a workspace will be created or to use an existing workspace"
  type        = bool
  default     = true
}

variable "workspace_id" {
  description = "The ID of an existing workspace to use when `create_workspace` is `false`"
  type        = string
  default     = ""
}

variable "workspace_alias" {
  description = "Alias (Name) of the Prometheus workspace, should be unique (for readability not enforced) in the account"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to the resources"
  type        = map(string)
  default     = {}
}

variable "logging_configuration" {
  description = "The logging configuration of the workspace"
  type        = map(string)
  default     = {}
}

variable "alert_manager_definition" {
  description = "The alert manager definition that you want to be applied."
  type        = string
  default     = <<-EOT
    alertmanager_config: |
      route:
        receiver: 'default'
      receivers:
        - name: 'default'
  EOT
}

variable "rule_group_namespaces" {
  description = "A map of one or more rule group namespace definitions"
  type        = map(any)
  default     = {}
}