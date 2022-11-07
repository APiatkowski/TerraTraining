variable "bits" {
  description = "Bits in the created RSA key"
  type        = number
  default     = 4096

  validation {
    condition     = var.bits >= 2048
    error_message = "Bits need to be at least 2048. It's 21st century, come on."
  }
}

variable "username" {
  description = "User name to save file with a key"
  type        = string
  default     = null
}
