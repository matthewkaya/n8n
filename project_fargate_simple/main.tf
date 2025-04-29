provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  n8n_port     = var.n8n_port
}

module "ecs" {
  source = "./modules/ecs"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.network.vpc_id
  public_subnets   = module.network.public_subnets
  security_group_id = module.network.security_group_id
  n8n_port         = var.n8n_port
  n8n_image        = var.n8n_image
}

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.network.vpc_id
}

output "n8n_access_command" {
  description = "Command to get n8n public IP"
  value       = module.ecs.n8n_public_ip
}

output "n8n_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs.ecs_cluster_name
}

output "n8n_service_name" {
  description = "The name of the ECS service"
  value       = module.ecs.fargate_service_name
}

output "n8n_access_url" {
  description = "Command to get n8n access URL"
  value       = "Get n8n public IP with the command above, then access n8n at http://<public_ip>:${var.n8n_port}"
}