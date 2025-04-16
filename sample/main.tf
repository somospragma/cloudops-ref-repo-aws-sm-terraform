###########################################
############ Secrets Manager module #################
###########################################

module "secrets_manager" {
  source = "../"
  providers = {
    aws.project = aws.principal
  }

  # Common configuration
  client      = var.client
  project     = var.project
  environment = var.environment
  additional_tags = var.additional_tags

  # Configuración de secretos usando mapa de objetos
  secrets_config = var.secrets_config
}
