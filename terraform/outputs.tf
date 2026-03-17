output "ecr_repository_url" {
  value = aws_ecr_repository.app_repository.repository_url
}

output "ecs_cluster_name" { 
  value = aws_ecs_cluster.app_cluster.name
}