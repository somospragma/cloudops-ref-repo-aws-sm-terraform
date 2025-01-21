module "Secret" {
  source = "./module/secret"

  client      = var.client
  service     = var.service
  environment = var.environment

  secrets_config = [
  {
    description                     = "Secreto para la aplicación Hefesto"
    application                     = "${var.client}-${var.project}-${var.environment}-${var.service}-${var.application}"
    kms_key_id                      = var.kms_key_id
    recovery_window_in_days         = var.recovery_window_in_days
    force_overwrite_replica_secret  = var.force_overwrite_replica_secret
    replica = [
      # {
      #   region     = "us-east-2"
      #   kms_key_id = "arn:aws:kms:us-east-2:11111111:key/"
      # }
    ]
    secret_json = {
      username = "admin"
      password = "hefesto123"
    }
    secret_text = ""
  }
]
secret_policies = {
    # "${var.client}-${var.project}-${var.environment}-${var.service}-${var.application}" = jsonencode({
    #   Version = "2012-10-17"
    #   Statement = [
    #     {
    #       Effect    = "Allow"
    #       Principal = {
    #         AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
    #       }
    #       Action    = [
    #         "secretsmanager:GetSecretValue",
    #         "secretsmanager:DescribeSecret"
    #       ]
    #       Resource  = "*"
    #     }
    #   ]
    # })
  }  # Puede agregar aqui la poltica que requiera o puede dejarla sin completar y se le asociara una politica por defecto
}