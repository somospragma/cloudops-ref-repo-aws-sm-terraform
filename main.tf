locals {
  # Generar nombres estandarizados para los secretos
  secret_names = {
    for k, v in var.secrets_config : k => "${var.client}/${var.project}/${var.environment}/secret/${k}"
  }
}

# Recurso de Secret Manager - Solo el cascarón
resource "aws_secretsmanager_secret" "secret" {
  provider = aws.project
  for_each = var.secrets_config

  name        = local.secret_names[each.key]
  description = each.value.description

  # KMS key es obligatorio para garantizar el cifrado
  kms_key_id                     = each.value.kms_key_id
  recovery_window_in_days        = each.value.recovery_window_in_days
  force_overwrite_replica_secret = each.value.force_overwrite_replica_secret

  # Configuración de replicación entre regiones
  dynamic "replica" {
    for_each = each.value.replica
    content {
      region     = replica.value.region
      kms_key_id = replica.value.kms_key_id
    }
  }

  # Etiquetas - Solo Name y etiquetas adicionales específicas para este recurso
  tags = merge(
    {
      Name = local.secret_names[each.key]
    },
    each.value.additional_tags
  )
}

# Versión del secreto - OPCIONAL
# Solo se crea si se proporciona secret_json o secret_text Y create_secret_version = true
resource "aws_secretsmanager_secret_version" "secret" {
  provider = aws.project
  for_each = {
    for k, v in var.secrets_config : k => v 
    if(v.create_secret_version && (v.secret_json != null || v.secret_text != null))
  }

  secret_id = aws_secretsmanager_secret.secret[each.key].id
  
  # Usar secret_json si está definido, de lo contrario usar secret_text
  secret_string = each.value.secret_json != null ? jsonencode(each.value.secret_json) : each.value.secret_text
}

# Política de acceso al secreto - OPCIONAL
# Solo se crea si se proporciona una política en el campo policy
resource "aws_secretsmanager_secret_policy" "policy" {
  provider = aws.project
  for_each = {
    for k, v in var.secrets_config : k => v
    if v.policy != null
  }

  secret_arn = aws_secretsmanager_secret.secret[each.key].arn
  policy     = each.value.policy
}
