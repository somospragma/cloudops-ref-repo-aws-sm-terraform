
# **🚀 Módulo Terraform para Secret manager: cloudops-ref-repo-aws-sm-terraform**

## Descripción:

Este módulo de Terraform permite la creación y configuración de Secrets en AWS Secrets Manager. Incluye la definición de secretos, su versión, y la aplicación de políticas, permitiendo además la replicación de secretos en otras regiones si es necesario, el cual requiere de los siguientes recursos, los cuales debieron ser previamente creados:

- kms_key_id: Para el KMS del secreto.

Consulta CHANGELOG.md para la lista de cambios de cada versión. *Recomendamos encarecidamente que en tu código fijes la versión exacta que estás utilizando para que tu infraestructura permanezca estable y actualices las versiones de manera sistemática para evitar sorpresas.*

## Estructura del Módulo

El módulo cuenta con la siguiente estructura:

```bash
cloudops-ref-repo-aws-sm-terraform/
└── sample/
    ├── data.tf
    ├── main.tf
    ├── outputs.tf
    ├── providers.tf
    ├── terraform.auto.tfvars
    └── variables.tf
├── CHANGELOG.md
├── README.md
├── data.tf
├── main.tf
├── outputs.tf
├── variables.tf
```

- Los archivos principales del módulo (`data.tf`, `main.tf`, `outputs.tf`, `variables.tf`) se encuentran en el directorio raíz.
- `CHANGELOG.md` y `README.md` también están en el directorio raíz para fácil acceso.
- La carpeta `sample/` contiene un ejemplo de implementación del módulo.


## Uso del Módulo:

```hcl
module "secrets" {
  source = "./module/secrets"

  client      = "xxxx"
  environment = "xxxx"
  service     = "xxxx"

  secrets_config = [
    {
      description                     = "xxxx"
      application                     = "xxxx"
      kms_key_id                      = "xxxx" (llamarlo desde el modulo de kms de ser necesario)
      recovery_window_in_days         = "xxxx"
      force_overwrite_replica_secret  = "xxxx"
      replica                         = [
        {
          region     = "xxxx"
          kms_key_id = "xxxx"
        }
      ]
      secret_json                     = { username = "admin", password = "SuperSecret" }
      secret_text                     = "xxxx"
    }
  ]

  secret_policies = {
    "mi_aplicacion" = jsonencode({
      Version   = "2012-10-17"
      Statement = [
        {
          Effect    = "Allow"
          Principal = { AWS = "xxxx" }
          Action    = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
          Resource  = "*"
        }
      ]
    })
  }
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.project"></a> [aws.project](#provider\_aws) | >= 4.31.0 |

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.secret](https://registry.terraform.io/providers/hashicorp/aws/3.28.0/docs/resources/secretsmanager_secret) | resource |
| [aws_api_gateway_resource.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/3.28.0/docs/resources/secretsmanager_secret_policy) | resource |



## 📌 Variables

| Nombre                               | Tipo                                                                                                                           | Descripción                                               | Predeterminado | Obligatorio |
|-------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------|----------------|-------------|
| `client`                            | `string`                                                                                                                       | Identificador del cliente.                                |                | Sí          |
| `environment`                       | `string`                                                                                                                       | Entorno de despliegue (por ejemplo, `dev`, `staging`, `prod`). |                | Sí          |
| `service`                           | `string`                                                                                                                       | Nombre del servicio o aplicación que utilizará el secreto. |                | Sí          |
| `secret_policies`                   | `map(any)`                                                                                                                     | Mapa de políticas dinámicas para los secretos. Permite asignar una política personalizada a cada secreto basado en su `application`. |                | Sí          |

### `secrets_config`

**Tipo:** `list(object)`

**Descripción:** Lista de configuraciones para cada secreto en Secrets Manager. Cada objeto permite definir la descripción, cifrado, replicación y el contenido del secreto.

**Estructura del objeto:**

```hcl
object({
  description                    = string
  application                    = string
  kms_key_id                     = string
  recovery_window_in_days        = string
  force_overwrite_replica_secret = string
  replica = list(object({
    region     = string
    kms_key_id = string
  }))
  secret_json = map(string)
  secret_text = string
})
```

### 📤 Outputs
| Nombre         | Descripción                                         |
|----------------|-----------------------------------------------------|
| `secret_arns`  | Mapa que relaciona cada aplicación con su ARN correspondiente en Secrets Manager. |




