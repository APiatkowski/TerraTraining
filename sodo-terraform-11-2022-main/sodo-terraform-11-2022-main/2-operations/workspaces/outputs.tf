output "public_info" {
  description = "Created RSA key with its codename"
  value = {
    codename    = random_pet.codename.id
    fingerprint = tls_private_key.key.public_key_fingerprint_md5
    public_key  = tls_private_key.key.public_key_openssh
  }
}

output "private_info" {
  description = "Created RSA key with its codename"
  sensitive   = true
  value = {
    codename    = random_pet.codename.id
    private_key = tls_private_key.key.private_key_openssh
  }
}
