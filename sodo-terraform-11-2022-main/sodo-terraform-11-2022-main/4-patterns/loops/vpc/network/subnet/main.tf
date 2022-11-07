/***********************
*
* This is a placeholder
*
* Put a real code here
*
************************/

variable "config" {
  type = map(any)
}

output "name" {
  value = var.config.name
}
output "id" {
  value = "subnet_id"
}

output "route_table_id" {
  value = "route-table-id"
}