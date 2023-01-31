locals {
  namespaced_service_name = "${var.service_name}-${var.env}"

  lambdas_path = "${path.module}/../lambdas"
  layer_path   = "${path.module}/../layer"

  lambdas = {
    "post" = {
      "descriptions" = "Create New todo"
      "memory"       = 128
      "timeout"      = 5
    }

    "get" = {
      "descriptions" = "Get todos"
      "memory"       = 256
      "timeout"      = 10
    }

    "update" = {
      "descriptions" = "Update given todo"
      "memory"       = 128
      "timeout"      = 5
    }

    "delete" = {
      "descriptions" = "Delete given todo"
      "memory"       = 128
      "timeout"      = 5
    }
  }
}
