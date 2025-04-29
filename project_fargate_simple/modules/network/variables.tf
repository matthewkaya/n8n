variable "project_name" {
  description = "Project name to be used for tagging resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "n8n_port" {
  description = "Port for n8n service"
  type        = number
  default     = 5678
}