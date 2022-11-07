variable "username" {
  type        = string
  default     = "default-username"
  description = "used in the bucket name"
}

variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region. What did you expect?"
}