resource "tls_private_key" "alice" {
  algorithm = "RSA"
  rsa_bits  = var.bits
}

resource "local_sensitive_file" "alice" {
  content  = tls_private_key.alice.private_key_openssh
  filename = "${path.module}/alice"
}

resource "tls_private_key" "bob" {
  algorithm = "RSA"
  rsa_bits  = var.bits
}

resource "local_sensitive_file" "bob" {
  content  = tls_private_key.bob.private_key_openssh
  filename = "${path.module}/bob"
}
