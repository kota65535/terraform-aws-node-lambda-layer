resource "terraform_data" "create_lambda_layer" {
  triggers_replace = [var.name, var.output_path, file(var.package_json_path)]
  provisioner "local-exec" {
    command     = "'./${path.module}/scripts/create_lambda_layer.sh' ${var.nodejs_version} ${var.package_json_path} ${var.output_path}"
    interpreter = ["bash", "-c"]
  }
}

resource "aws_lambda_layer_version" "main" {
  layer_name          = var.name
  filename            = var.output_path
  compatible_runtimes = ["nodejs${regex("^(\\d+)(\\.\\d+\\.\\d+)?", var.nodejs_version)[0]}.x"]
  source_code_hash    = ""
  lifecycle {
    replace_triggered_by = [terraform_data.create_lambda_layer]
    ignore_changes       = [source_code_hash]
  }
}
