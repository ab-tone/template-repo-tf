variable "project_id" {
  description = "The ID of the project where resources will be created"
  type        = string
}

variable "enable_apis" {
  # https://cloud.google.com/docs/terraform/best-practices-for-terraform#activate-apis
  description = "Set to `true` to prevent enable the apis, or `false` to retain existing enabled apis for the project (default=`true`)"
  type        = bool
  default     = true
}

variable "remove_previous" {
  description = "Set to `true` to remove any existing network named 'default', or `false` to leave it in place (default=`true`)"
  type        = bool
  default     = true
}
