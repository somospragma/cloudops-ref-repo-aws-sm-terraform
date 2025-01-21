variable "client" {
  type = string
}
variable "environment" {
  type = string
}
variable "service"{
  type = string  
}
variable "aws_region" {
  type = string
}
variable "profile" {
  type = string
}
variable "common_tags" {
    type = map(string)
    description = "Tags comunes aplicadas a los recursos"
}
variable "project" {
  type = string  
}


########### Varibales Secret Manager

variable "application" {
  type        = string  
  description = "Nombre del secreto"
}
variable "kms_key_id" {
  type        = string  
  description = "kms asociada al secreto"
  default     = null
}
variable "recovery_window_in_days" {
  type        = number  
  description = "numero de ventana de recuperación en caso de eliminación"
  default     = 7
}
variable "force_overwrite_replica_secret" {
  type        = bool 
  description = "Replica automaticamente los datos en todas las regiones donde se este replicando"
  default     = true
}



