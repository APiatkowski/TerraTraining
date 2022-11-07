locals {
  username = var.username == null ? null : "${terraform.workspace}-${var.username}"
}

resource "random_pet" "codename" {
  length = 2
  keepers = {
    # Generate a new codename each time the key changes (for example when tainted/recreated)
    key = tls_private_key.key.private_key_openssh
  }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = var.bits
}

resource "local_sensitive_file" "user_keys" {
  count    = var.username == null ? 0 : 1
  content  = tls_private_key.key.private_key_openssh
  filename = "${path.module}/${var.username}"
}
