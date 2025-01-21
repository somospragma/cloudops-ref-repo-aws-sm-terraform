variable "secrets_config" {
  type = list(object({
    description = string
    application = string
    kms_key_id = string
    recovery_window_in_days = string
    force_overwrite_replica_secret = string
    replica = list(object({
      region = string
      kms_key_id = string
    }))
    secret_json = map(string)
    secret_text = string
  }))
}

variable "secret_policies" {
  type = map(any)
  description = "Políticas dinámicas para los secretos"
}


variable "service" {
  type = string
}

variable "client" {
  type = string
}

variable "environment" {
  type = string
}