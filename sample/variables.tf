###########################################
########## Common variables ###############
###########################################

variable "profile" {
  description = "Perfil de AWS a utilizar"
  type        = string
}

variable "common_tags" {
  description = "Etiquetas comunes aplicadas a los recursos"
  type        = map(string)
}

variable "additional_tags" {
  description = "Etiquetas adicionales para los recursos que no son secretos"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "Región de AWS donde se desplegarán los recursos"
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue (dev, qa, pdn)"
  type        = string
  
  validation {
    condition     = contains(["dev", "qa", "pdn"], var.environment)
    error_message = "El entorno debe ser uno de: dev, qa, pdn."
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

variable "project" {
  description = "Nombre del proyecto"
  type        = string
  validation {
    condition     = length(var.project) > 0
    error_message = "El valor de project no puede estar vacío."
  }
}

variable "service" {
  description = "Nombre del servicio o aplicación que utilizará el secreto"
  type        = string
  
}

###########################################
########## Secrets Manager variables ###############
###########################################

variable "secrets_config" {
  description = "Configuración de secretos en AWS Secrets Manager"
  type = map(object({
    description                     = string
    kms_key_id                      = string
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
}
