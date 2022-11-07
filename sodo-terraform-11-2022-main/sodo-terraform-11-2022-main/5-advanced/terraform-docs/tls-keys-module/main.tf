/**
 * # TLS-KEYS-MODULE
 *
 * This module creates TLS keypair and has all defaults set up.
 *
 * You can use it to create non-sensitive private keys, too.
 */

resource "tls_private_key" "keys" {
  algorithm   = var.algorithm
  ecdsa_curve = var.algorithm == "ECDSA" ? var.ecdsa_curve : null
  rsa_bits    = var.algorithm == "RSA" ? var.rsa_bits : null
}