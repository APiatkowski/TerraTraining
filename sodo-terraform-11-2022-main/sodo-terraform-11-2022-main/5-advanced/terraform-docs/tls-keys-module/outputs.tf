output "public_ssh" {
  value       = tls_private_key.keys.public_key_openssh
  description = "Public key in OpenSSH format"
}

output "private_ssh" {
  value       = nonsensitive(tls_private_key.keys.private_key_openssh)
  description = "Private key in OpenSSH format"
}