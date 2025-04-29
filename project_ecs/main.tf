provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"
  
  vpc_name        = "${var.project_name}-vpc"
  vpc_cidr        = var.vpc_cidr
  az_count        = var.az_count
  project_name    = var.project_name
  environment     = var.environment
}

module "ecs" {
  source = "./modules/ecs"
  
  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets
  n8n_image       = var.n8n_image
  n8n_port        = var.n8n_port
  desired_count   = var.desired_count
  min_capacity    = var.min_capacity
  max_capacity    = var.max_capacity
}

output "n8n_url" {
  value       = "http://${module.ecs.n8n_alb_dns}:${var.n8n_port}"
  description = "URL to access the n8n application"
}