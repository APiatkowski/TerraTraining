variable "username" {
  type        = string
  description = "User name"
}

variable "length" {
  type    = number
  default = 30
  description = "User password length"
}

resource "random_password" "password" {
  length  = var.length
  special = true
  
  override_special = "_%@"
}

resource "random_password" "salt" {
  length = 8
}

resource "htpasswd_password" "hash" {
  password = random_password.password.result
  salt     = random_password.salt.result
}

output "entry" {
  value = "${var.username}:${htpasswd_password.hash.apr1}"
  description = "A line to add to .htpasswd"
}

output "passwd" {
  value = nonsensitive(random_password.password.result)
}

terraform {
required_providers {
  htpasswd = {
    source  = "loafoe/htpasswd"
    version = "~> 1.0"
  }
}
}