variable "name" {
  description = "Lambda layer name"
  type        = string
}

variable "nodejs_version" {
  description = "Node.js version"
  type        = string
}

variable "package_json_path" {
  description = "package.json file path"
  type        = string
  validation {
    condition     = fileexists(var.package_json_path)
    error_message = "The package.json file does not exist"
  }
}

variable "output_path" {
  description = "Output file path"
  type        = string
}
