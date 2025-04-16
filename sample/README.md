# Ejemplo de implementación del módulo AWS Secrets Manager

Este directorio contiene un ejemplo completo de cómo implementar el módulo de AWS Secrets Manager. El ejemplo muestra cómo crear múltiples secretos con diferentes configuraciones, incluyendo secretos básicos, secretos con replicación entre regiones y secretos con valores de prueba.

## Estructura de archivos

```
sample/
├── data.tf              # Data sources utilizados en el ejemplo
├── main.tf              # Implementación del módulo
├── outputs.tf           # Outputs del ejemplo
├── providers.tf         # Configuración del proveedor AWS
├── README.md            # Este archivo
├── terraform.auto.tfvars # Variables de ejemplo (renombrar a terraform.auto.tfvars para usar)
└── variables.tf         # Definición de variables
```

## Requisitos previos

1. [Terraform](https://www.terraform.io/downloads.html) (versión >= 1.0.0)
2. [AWS CLI](https://aws.amazon.com/cli/) configurado con las credenciales adecuadas
3. Permisos IAM para crear y gestionar recursos de AWS Secrets Manager

## Cómo usar este ejemplo

1. **Preparar las variables**:
   - Revise y modifique el archivo `terraform.auto.tfvars` según sus necesidades
   - Asegúrese de actualizar los valores de `profile`, `aws_region`, `client`, `project`, `environment` y `common_tags`

2. **Inicializar Terraform**:
   ```bash
   terraform init
   ```

3. **Verificar el plan de ejecución**:
   ```bash
   terraform plan
   ```

4. **Aplicar la configuración**:
   ```bash
   terraform apply
   ```

5. **Verificar los recursos creados**:
   - Compruebe los secretos creados en la consola de AWS Secrets Manager
   - Revise los outputs de Terraform para obtener los ARNs y nombres de los secretos

## Ejemplos incluidos

### 1. Secreto básico sin replicación

```hcl
"usuarios" = {
  description                    = "Secreto para la aplicación usuarios"
  kms_key_id                     = "alias/aws/secretsmanager"
  recovery_window_in_days        = 7
  force_overwrite_replica_secret = true
  replica                        = []
  create_secret_version          = false
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::840021737375:root"
      },
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "*"
    }
  ]
}
EOF
  additional_tags = {
    application = "usuarios"
    data-classification = "confidential"
  }
}
```

### 2. Secreto con replicación en múltiples regiones

```hcl
"multi-region-secret" = {
  description                    = "Secreto replicado en múltiples regiones"
  kms_key_id                     = "alias/aws/secretsmanager"
  recovery_window_in_days        = 7
  force_overwrite_replica_secret = true
  
  # Configuración de replicación
  replica = [
    {
      region     = "us-west-2"
      kms_key_id = "alias/aws/secretsmanager"
    },
    {
      region     = "eu-west-1"
      kms_key_id = "alias/aws/secretsmanager"
    }
  ]
  
  create_secret_version          = false
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::840021737375:root"
      },
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "*"
    }
  ]
}
EOF
  
  additional_tags = {
    application = "global-app"
    data-classification = "confidential"
    replication = "multi-region"
  }
}
```

### 3. Secreto con versión (solo para desarrollo/pruebas)

```hcl
"test-secret" = {
  description                    = "Secreto de prueba (solo para desarrollo)"
  kms_key_id                     = "alias/aws/secretsmanager"
  recovery_window_in_days        = 7
  force_overwrite_replica_secret = true
  replica                        = []
  # Creamos la versión del secreto desde Terraform (solo para desarrollo)
  create_secret_version          = true
  secret_json = {
    test_key = "test_value"
  }
  additional_tags = {
    application = "testing"
    data-classification = "internal"
  }
}
```

## Gestión de secretos después de la creación

Para los secretos creados con `create_secret_version = false`, deberá agregar el contenido sensible después de la creación. Puede hacerlo de varias maneras:

### Usando AWS Console

1. Inicie sesión en la consola de AWS
2. Navegue a AWS Secrets Manager
3. Seleccione el secreto creado
4. Haga clic en "Retrieve secret value" y luego en "Edit"
5. Ingrese el valor del secreto y guarde los cambios

### Usando AWS CLI

```bash
# Para secretos en formato JSON
aws secretsmanager put-secret-value \
    --secret-id "pragma-secret-dev-secret-usuarios" \
    --secret-string '{"username":"admin","password":"SecurePassword123!"}'

# Para secretos en formato texto
aws secretsmanager put-secret-value \
    --secret-id "pragma-secret-dev-secret-api-key" \
    --secret-string "api-key-value-here"
```

## Limpieza

Para eliminar todos los recursos creados:

```bash
terraform destroy
```

> **Nota**: La eliminación de secretos está sujeta al período de recuperación configurado (por defecto 7 días). Si necesita eliminar un secreto inmediatamente, puede establecer `recovery_window_in_days = 0` en la configuración del secreto.

## Consideraciones de seguridad

- Este ejemplo utiliza la clave KMS predeterminada de AWS (`alias/aws/secretsmanager`). En entornos de producción, considere usar una clave KMS personalizada.
- Las políticas de acceso en este ejemplo son permisivas para facilitar las pruebas. En entornos de producción, siga el principio de privilegio mínimo.
- Nunca almacene datos sensibles reales en archivos de configuración de Terraform o en sistemas de control de versiones.
- Considere implementar monitoreo y auditoría adicionales para los secretos críticos.
