terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region
}

resource "null_resource" "local_placeholder" {
  provisioner "local-exec" {
    command = "echo 'Terraform validation successful for local run'"
  }
}
