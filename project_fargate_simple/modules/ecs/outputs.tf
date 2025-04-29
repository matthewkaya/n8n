output "fargate_service_id" {
  description = "The ID of the Fargate service"
  value       = aws_ecs_service.n8n_service.id
}

output "fargate_service_name" {
  description = "The name of the Fargate service"
  value       = aws_ecs_service.n8n_service.name
}

output "task_definition_arn" {
  description = "The ARN of the task definition"
  value       = aws_ecs_task_definition.n8n_task.arn
}

output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.n8n_cluster.name
}

output "n8n_public_ip" {
  description = "The public IP address of the Fargate task"
  value       = "Run 'aws ecs describe-tasks --cluster ${aws_ecs_cluster.n8n_cluster.name} --tasks $(aws ecs list-tasks --cluster ${aws_ecs_cluster.n8n_cluster.name} --service-name ${aws_ecs_service.n8n_service.name} --query 'taskArns[0]' --output text) --query \"tasks[0].attachments[0].details[?name=='networkInterfaceId'].value\" --output text | xargs -I {} aws ec2 describe-network-interfaces --network-interface-ids {} --query 'NetworkInterfaces[0].Association.PublicIp' --output text' to get the public IP"
}