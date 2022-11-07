variable "simple_string" {
  type = string
}

variable "simple_list" {
  type = list(any)

  validation {
    condition     = length(var.simple_list) == 2 && substr(var.simple_list[0], -1, -1) == "." && substr(var.simple_list[1], -1, -1) == "."
    error_message = "The simple_list needs two elements and each one needs to end with dot."
  }
}

variable "implicit_type" {}

variable "simple_map" {
  type = map(any)
}

output "simple_string" {
  value = var.simple_string
}

output "simple_list" {
  value = var.simple_list
}

output "simple_map" {
  value = var.simple_map
}

output "implicit_string" {
  value = var.implicit_type
}
