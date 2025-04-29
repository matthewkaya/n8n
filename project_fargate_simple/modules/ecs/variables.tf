variable "project_name" {
  description = "Project name to be used for tagging resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
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

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "IDs of the public subnets"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID of the security group"
  type        = string
}