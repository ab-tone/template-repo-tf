<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.1 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.53 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.53 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcloud"></a> [gcloud](#module\_gcloud) | git::https://github.com/terraform-google-modules/terraform-google-gcloud.git/ | 847e96e764a7928a0a8420e7d7b63fc9912f3dc0 |
| <a name="module_project_services"></a> [project\_services](#module\_project\_services) | git::https://github.com/terraform-google-modules/terraform-google-project-factory.git//modules/project_services | 982646180605abed67bdd7af586b2f8c02941ff0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_apis"></a> [enable\_apis](#input\_enable\_apis) | Set to `true` to prevent enable the apis, or `false` to retain existing enabled apis for the project (default=`true`) | `bool` | `true` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project where resources will be created | `string` | n/a | yes |
| <a name="input_remove_previous"></a> [remove\_previous](#input\_remove\_previous) | Set to `true` to remove any existing network named 'default', or `false` to leave it in place (default=`true`) | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
