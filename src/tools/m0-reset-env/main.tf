module "project_services" {
  # https://github.com/terraform-google-modules/terraform-google-project-factory/releases
  # source  = "terraform-google-modules/project-factory/google//modules/project_services"
  # version = "14.4" # 982646180605abed67bdd7af586b2f8c02941ff0"
  source = "git::https://github.com/terraform-google-modules/terraform-google-project-factory.git//modules/project_services?ref=982646180605abed67bdd7af586b2f8c02941ff0"

  project_id = var.project_id

  # ref. https://cloud.google.com/docs/terraform/best-practices-for-terraform#activate-apis
  #   - parameterise enable_apis
  #   - set disable_services_on_destroy = false
  enable_apis                 = var.enable_apis
  disable_services_on_destroy = false

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com"
  ]
}

module "gcloud" {
  # https://github.com/terraform-google-modules/terraform-google-gcloud/releases
  # source  = "terraform-google-modules/gcloud/google"
  # version = "3.3" # 847e96e764a7928a0a8420e7d7b63fc9912f3dc0
  source = "git::https://github.com/terraform-google-modules/terraform-google-gcloud.git/?ref=847e96e764a7928a0a8420e7d7b63fc9912f3dc0"

  module_depends_on = [module.project_services]

  create_cmd_entrypoint = "chmod +x ${path.module}/scripts/hose_default_vpc.sh; ${path.module}/scripts/hose_default_vpc.sh ${var.project_id}"
}
