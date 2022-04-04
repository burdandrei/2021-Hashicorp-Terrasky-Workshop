resource "tfe_workspace" "rds" {
  name         = "RDS"
  organization = var.tfc_organization_name
  tag_names    = ["devopsdaystlv2021"]
  vcs_repo {
    identifier     = "${var.github_username}/2021-Hashicorp-Terrasky-Workshop"
    oauth_token_id = var.oauth_token_id
  }
  working_directory   = "05-rds"
  execution_mode      = "remote"
  auto_apply          = true
  global_remote_state = true
  queue_all_runs      = false

}


resource "tfe_run_trigger" "vpc-rds" {
  workspace_id  = tfe_workspace.rds.id
  sourceable_id = tfe_workspace.vpc.id
}
