output "db_instance_ip" {
  value = aws_instance.journal_db.private_ip
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.journal.name
}

output "ecs_service_name" {
  value = aws_ecs_service.journal.name
}

