variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project name to be used for tagging resources"
  type        = string
  default     = "n8n-simple"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
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

variable "n8n_image" {
  description = "Docker image for n8n"
  type        = string
  default     = "n8nio/n8n:latest"
}