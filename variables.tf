variable "deployment_role_enabled" {
  description = "Whether to create a deployment role."
  type        = bool
  nullable    = false
  default     = true
}

variable "deployment_role_name" {
  description = "Name of the deployment role."
  type        = string
  nullable    = false
  default     = "Deployment"
}

variable "deployment_policy_name" {
  description = "Name of the deployment policy."
  type        = string
  nullable    = false
  default     = "DeploymentPolicy"
}

variable "deployment_policy_json" {
  description = "JSON string of the deployment policy."
  type        = string
  nullable    = false
  default     = "{}"
}

variable "deploy_from_github_repos" {
  description = "List of GitHub to permit deployments from. Entries should be in Owner/Repository format."
  type        = list(string)
  nullable    = false
  default     = []
}

variable "developer_role_enabled" {
  description = "Whether to create a developer role."
  type        = bool
  nullable    = false
  default     = true
}

variable "developer_role_name" {
  description = "Name of the developer role."
  type        = string
  nullable    = false
  default     = "Developer"
}

variable "developer_policy_name" {
  description = "Name of the developer policy."
  type        = string
  nullable    = false
  default     = "DeveloperPolicy"
}

variable "developer_policy_json" {
  description = "JSON string of the developer policy."
  type        = string
  nullable    = false
  default     = "{}"
}

variable "developer_inherits_deployment_policy" {
  description = "Whether the developer role should inherit the deployment policy"
  type        = bool
  nullable    = false
  default     = true
}

variable "developer_access_from" {
  description = "List of accounts and conditions for allowing users to assume the developer role."
  type = list(object({
    sid        = string
    account_id = string
    conditional = optional(object({
      test     = string
      variable = string
      values   = list(string)
    }))
  }))
  nullable = false
  default  = []
}

variable "support_role_enabled" {
  description = "Whether to create a support role."
  type        = bool
  nullable    = false
  default     = true
}

variable "support_role_name" {
  description = "Name of the support role."
  type        = string
  nullable    = false
  default     = "Developer"
}

variable "support_policy_name" {
  description = "Name of the support policy."
  type        = string
  nullable    = false
  default     = "DeveloperPolicy"
}

variable "support_policy_json" {
  description = "JSON string of the support policy."
  type        = string
  nullable    = false
  default     = "{}"
}

variable "support_access_from" {
  description = "List of accounts and conditions for allowing users to assume the support role."
  type = list(object({
    sid        = string
    account_id = string
    conditional = optional(object({
      test     = string
      variable = string
      values   = list(string)
    }))
  }))
  nullable = false
  default  = []
}
