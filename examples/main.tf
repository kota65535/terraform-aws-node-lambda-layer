module "lambda_layer" {
  source            = "../"
  name              = "test"
  nodejs_version    = "20"
  package_json_path = "package.json"
  output_path       = "${path.root}/test-layer.zip"
}
