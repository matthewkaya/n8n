variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "IDs of public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "IDs of private subnets"
  type        = list(string)
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