locals {
  namespaced_service_name = "${var.service_name}-${var.env}"

  lambdas_path = "${path.module}/../lambdas"
  layer_path   = "${path.module}/../layer"

  get_functions    = fileset(local.lambdas_path, "**/get.py")
  post_functions   = fileset(local.lambdas_path, "**/post.py")
  put_functions    = fileset(local.lambdas_path, "**/put.py")
  delete_functions = fileset(local.lambdas_path, "**/delete.py")

  lambdas = toset(
    concat(
      tolist(local.get_functions),
      tolist(local.post_functions),
      tolist(local.put_functions),
      tolist(local.delete_functions)
    )
  )
}
