variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "n8n"
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

variable "az_count" {
  description = "Number of availability zones to use"
  type        = number
  default     = 2
}

variable "n8n_image" {
  description = "Docker image for n8n"
  type        = string
  default     = "n8nio/n8n:latest"
}

variable "n8n_port" {
  description = "Port on which n8n runs"
  type        = number
  default     = 5678
}

variable "desired_count" {
  description = "Desired number of containers"
  type        = number
  default     = 1
}

variable "min_capacity" {
  description = "Minimum number of containers"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of containers"
  type        = number
  default     = 5
}