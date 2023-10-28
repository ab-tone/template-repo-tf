<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.1 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.53 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.53 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_reset_env"></a> [reset\_env](#module\_reset\_env) | ../m0-reset-env | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.allow_icmp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_rdp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.allow_ssh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_network.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_zones.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_vpc_nm"></a> [default\_vpc\_nm](#input\_default\_vpc\_nm) | The name for the default network | `string` | `"default"` | no |
| <a name="input_enable_apis"></a> [enable\_apis](#input\_enable\_apis) | Set to `true` to prevent enable the apis, or `false` to retain existing enabled apis for the project (default=`true`) | `bool` | `true` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project where resources will be created | `string` | n/a | yes |
| <a name="input_rdp_ssh_source_ranges"></a> [rdp\_ssh\_source\_ranges](#input\_rdp\_ssh\_source\_ranges) | A list of source ranges that are to be allowed for ssh and rdp | <pre>list(object({<br>    name_suffix = string<br>    ip_range    = string<br>  }))</pre> | `[]` | no |
| <a name="input_remove_previous"></a> [remove\_previous](#input\_remove\_previous) | Set to `true` to remove any existing network named 'default', or `false` to leave it in place (default=`true`) | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_zones"></a> [zones](#output\_zones) | Available zones in region |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
