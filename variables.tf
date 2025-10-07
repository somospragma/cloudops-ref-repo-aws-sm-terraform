variable "secrets_config" {
  description = "Configuración de secretos en AWS Secrets Manager"
  type = map(object({
    description                     = string
    kms_key_id                      = string  # Ahora es obligatorio para garantizar el cifrado
    recovery_window_in_days         = optional(number, 7)
    force_overwrite_replica_secret  = optional(bool, true)
    replica = optional(list(object({
      region     = string
      kms_key_id = string
    })), [])
    # Campos opcionales para el contenido del secreto
    secret_json                     = optional(map(string))
    secret_text                     = optional(string)
    # Flag para controlar si se crea la versión del secreto
    create_secret_version           = optional(bool, false)
    # Política del secreto (opcional)
    policy                          = optional(string)
    # Etiquetas adicionales
    additional_tags                 = optional(map(string), {})
  }))
  
  validation {
    condition = alltrue([
      for k, v in var.secrets_config : 
      !v.create_secret_version || 
      ((v.secret_json != null || v.secret_text != null) && 
      !(v.secret_json != null && v.secret_text != null))
    ])
    error_message = "Si create_secret_version es true, debe proporcionar secret_json O secret_text para cada secreto, pero no ambos."
  }
  
  validation {
    condition = alltrue([
      for k, v in var.secrets_config : 
      v.recovery_window_in_days == null || 
      (v.recovery_window_in_days >= 0 && v.recovery_window_in_days <= 30)
    ])
    error_message = "El valor de recovery_window_in_days debe estar entre 0 y 30 días."
  }
  
  validation {
    condition = alltrue([
      for k, v in var.secrets_config : 
      v.kms_key_id != null && v.kms_key_id != ""
    ])
    error_message = "El valor de kms_key_id es obligatorio para garantizar el cifrado de los secretos. Puede usar 'alias/aws/secretsmanager' para la clave predeterminada de AWS."
  }
}

variable "client" {
  description = "Identificador del cliente"
  type        = string
  
  validation {
    condition     = length(var.client) > 0
    error_message = "El valor de client no puede estar vacío."
  }
}


variable "environment" {
  description = "Entorno de despliegue (dev, qa, pdn, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "qa", "prod", "pdn"], var.environment)
    error_message = "El entorno debe ser uno de: dev, qa, pdn, prod"
  }
}

variable "additional_tags" {
  description = "Etiquetas adicionales para los recursos que no son secretos"
  type        = map(string)
  default     = {}
}

variable "project" {
  description = "Nombre del projecto que utilizará el secreto"
  type        = string
  validation {
    condition     = length(var.project) > 0
    error_message = "El valor de project no puede estar vacío."
  }
}
