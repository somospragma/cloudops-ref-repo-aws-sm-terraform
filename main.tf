resource "aws_secretsmanager_secret" "secret" {
  for_each = { for item in var.secrets_config :
    item.application => {
      "index" : index(var.secrets_config, item)
      "description" : item.description
      "kms_key_id" : item.kms_key_id
      "recovery_window_in_days" : item.recovery_window_in_days
      "force_overwrite_replica_secret" : item.force_overwrite_replica_secret
      "replica" : item.replica
    }
  }

  name        = each.key
  description = each.value["description"]

  kms_key_id                     = each.value["kms_key_id"]
  recovery_window_in_days        = each.value["recovery_window_in_days"]
  force_overwrite_replica_secret = each.value["force_overwrite_replica_secret"]

  dynamic "replica" {
    for_each = each.value["replica"]
    content {
    region     = replica.value["region"]
    kms_key_id = replica.value["region"]
  }
  }
 

  tags = merge({ Name = "${each.key}" })
}


resource "aws_secretsmanager_secret_version" "secret" {
  for_each = { for item in var.secrets_config :
    item.application => {
      "index" : index(var.secrets_config, item)
      "secret_json" : item.secret_json
      "secret_text" : item.secret_text
    }
  }
  secret_id     = aws_secretsmanager_secret.secret[each.key].id
  secret_string = each.value["secret_json"] != null ? jsonencode(each.value["secret_json"]) : each.value["secret_text"] //todo: check
}

resource "aws_secretsmanager_secret_policy" "policy" {
  for_each   = aws_secretsmanager_secret.secret
  secret_arn = each.value.arn
  policy = lookup(
    var.secret_policies,
    each.key,
    jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect    = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          }
          Action    = [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
          ]
          Resource  = each.value.arn
        }
      ]
    })
  )
}
