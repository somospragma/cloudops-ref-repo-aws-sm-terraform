output "secret_arns" {
  description = "ARNs de los secretos creados"
  value       = { for k, v in aws_secretsmanager_secret.secret : k => v.arn }
}
