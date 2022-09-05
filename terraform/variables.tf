variable "env" {
  type    = string
  default = "test"
}

variable "secret_path" {
  type = string
}

variable "thanos_values_file" {
  description = "Thanos values yaml file to load"
  type        = string
  #   default = "values/values-${var.env}.yaml"
  default = "values/values-test.yaml"

}

variable "namespace" {
  type    = string
  default = "default"
}

variable "bucket_name" {
  description = "Name of bucket where logs are stored"
  type        = string
}

variable "bucket_key" {
  description = "path to store tf state file"
  type        = string
}

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "tf_state_bucket" {
  description = "Name of bucket where tf state is stored"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)

  default = {
    "Service"     = "Dan"
    "Team"        = "Dans Team"
    "Environment" = "Test"
  }
}

variable "vault_address" {
  type = string
  default = "http://127.0.0.1:8200"
}

variable "commonAnnotations" {
  type = map(string)

  default = {
    "anotribe" = "dan"
    "anodomain" = "my_ano_domain"
    "anosquad" = "dan_squad_ano"
  }
  
}