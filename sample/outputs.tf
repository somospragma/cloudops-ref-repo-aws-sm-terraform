output "secret_arns" {
  description = "ARNs de los secretos creados"
  value       = module.secrets_manager.secret_arns
}

output "secret_names" {
  description = "Nombres de los secretos creados"
  value       = module.secrets_manager.secret_names
}
