locals {
  namespaced_service_name = "${var.service_name}-${var.env}"

  lambdas_path = "${path.module}/../lambdas/todos"
  layer_path   = "${path.module}/../layer"

  lambdas = {
    "post" = {
      "description" = "Create New todo"
      "memory"      = 128
      "timeout"     = 5
    }

    "get" = {
      "description" = "Get todos"
      "memory"      = 256
      "timeout"     = 10
    }

    "put" = {
      "description" = "Update given todo"
      "memory"      = 128
      "timeout"     = 5
    }

    "delete" = {
      "description" = "Delete given todo"
      "memory"      = 128
      "timeout"     = 5
    }
  }
}
