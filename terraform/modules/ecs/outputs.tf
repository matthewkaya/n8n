output "cluster_id" {
  value = aws_ecs_cluster.n8n_cluster.id
}

output "service_name" {
  value = aws_ecs_service.n8n_service.name
}

output "n8n_alb_dns" {
  value = aws_lb.n8n_alb.dns_name
}