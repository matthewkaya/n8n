output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.n8n_sg.id
}