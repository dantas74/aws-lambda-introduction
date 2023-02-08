locals {
  namespaced_service_name = "${var.service_name}-${var.env}"

  lambdas_path  = "${path.module}/../lambdas/todos"
  lambdas_path2 = "${path.module}/../lambdas"
  layer_path    = "${path.module}/../layer"

  get_functions    = fileset(local.lambdas_path2, "**/get.py")
  post_functions   = fileset(local.lambdas_path2, "**/post.py")
  put_functions    = fileset(local.lambdas_path2, "**/put.py")
  delete_functions = fileset(local.lambdas_path2, "**/delete.py")

  lambdas2 = toset(
    concat(
      tolist(local.get_functions),
      tolist(local.post_functions),
      tolist(local.put_functions),
      tolist(local.delete_functions)
    )
  )

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
