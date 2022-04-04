variable "tfc_organization_name" {
  type        = string
  description = "Terraform Cloud Organization Name"
}

variable "db_password" {
  description = "RDS root user password"
  sensitive   = true
}
