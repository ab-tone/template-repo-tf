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

variable "default_vpc_nm" {
  description = "The name for the default network"
  type        = string
  default     = "default"
}

variable "rdp_ssh_source_ranges" {
  type = list(object({
    name_suffix = string
    ip_range    = string
  }))

  description = "A list of source ranges that are to be allowed for ssh and rdp"
  default     = []

  validation {
    condition     = alltrue([for ip in var.rdp_ssh_source_ranges[*].ip_range : can(cidrhost(ip, 0))])
    error_message = "Must be valid IPv4 CIDR range or address."
  }

  validation {
    condition     = alltrue([for ip in var.rdp_ssh_source_ranges[*].ip_range : !startswith(ip, "0.0.0.0")])
    error_message = "Must not be 0.0.0.0/0 or a variant of 0.0.0.0/x"
  }
}
