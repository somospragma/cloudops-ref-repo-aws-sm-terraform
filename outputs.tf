output "secret_arns" {
  description = "ARNs de los secretos creados"
  value       = { for k, v in aws_secretsmanager_secret.secret : k => v.arn }
}

output "secret_names" {
  description = "Nombres de los secretos creados"
  value       = { for k, v in aws_secretsmanager_secret.secret : k => v.name }
}

output "secret_versions" {
  description = "IDs de las versiones de los secretos creados"
  value       = { for k, v in aws_secretsmanager_secret_version.secret : k => v.version_id }
  sensitive   = true
}
