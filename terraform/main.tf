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
  cleanup_on_fail = true
  timeout = 1000

  values = [
    "${file(var.thanos_values_file)}"
  ]

  set {
    name  = "thanos.query.replicaCount"
    value = 1
  }

  set {
    name  = "thanos.queryFrontend.replicaCount"
    value = 1
  }

  # set {
  #   name  = "thanos.query.extraEnvVars[0].name"
  #   value = "AWS_ACCESS_KEY"
  # }

  # set {
  #   name  = "thanos.query.extraEnvVars[0].value"
  #   value = data.vault_generic_secret.aws_credentials.data["aws_access_key"]
  # }

  # set {
  #   name  = "thanos.query.extraEnvVars[1].name"
  #   value = "AWS_SECRET_KEY"
  # }

  # set {
  #   name  = "thanos.query.extraEnvVars[1].value"
  #   value = data.vault_generic_secret.aws_credentials.data["aws_secret_key"]
  # }

  depends_on = [
    kubernetes_secret.thanos-auth
  ]

}

