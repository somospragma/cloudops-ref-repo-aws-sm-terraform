###############################################################
# Variables Globales
###############################################################


aws_region        = "us-east-1"
profile           = "pra_idp_dev"
environment       = "dev"
client            = "pragma"
project           = "hefesto"
service           = "secret"  


common_tags = {
  environment   = "dev"
  project-name  = "Modulos Referencia"
  cost-center   = "-"
  owner         = "cristian.noguera@pragma.com.co"
  area          = "KCCC"
  provisioned   = "terraform"
  datatype      = "interno"
}


###############################################################
# Variables Secrets
###############################################################
application                    = "usuarios"   # Nombre de la representación a nivel funcional del secreto 
#kms_key_id                    =               Aqui se podria llamar por medio de un data el arn del kms o bien se usa directo en el main con la salida del modulo de KMS 
recovery_window_in_days        = 7
force_overwrite_replica_secret = true