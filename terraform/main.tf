data "vault_generic_secret" "aws_credentials" {
  path = var.secret_path
}

resource "kubernetes_secret" "thanos-auth" {
  metadata {
    name      = "thanos-auth"
    namespace = "default"
  }

  data = {
    AWS_ACCESS_KEY = data.vault_generic_secret.aws_credentials.data["aws_access_key"]
    AWS_SECRET_KEY = data.vault_generic_secret.aws_credentials.data["aws_secret_key"]
  }

  depends_on = [
    data.vault_generic_secret.aws_credentials
  ]
}

resource "helm_release" "mythanos" {
  name      = "mythanos"
  namespace = var.namespace
  chart     = "../thanos"
  version   = "11.1.3"
  dependency_update = true
  lint = true

  values = [
    "${file(var.thanos_values_file)}"
  ]

  set {
    name  = "extraEnvVars[0].AWS_ACCESS_KEY"
    value = "JAVA_OPTS"
  }

  set {
    name  = "extraEnvVars[0].AWS_SECRET_KEY"
    value = " second one"
  }

  depends_on = [
    kubernetes_secret.thanos-auth
  ]

}

