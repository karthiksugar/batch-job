# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------
variable "region" {
  type = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "cluster_name" {
  description = "The name to set for the ECS cluster."
  type        = string
  default     = "terraform-example"
}

variable "service_name" {
  description = "The name to set for the ECS service."
  type        = string
  default     = "terraform-example"
}

variable "ecr_url" {
  type    = string
  default = "388352013833.dkr.ecr.us-east-1.amazonaws.com"
}

variable "repository_name" {
  type    = string
  default = "ecs-scheduled-job"
}

variable "tag" {
  type    = string
  default = "latest"
}