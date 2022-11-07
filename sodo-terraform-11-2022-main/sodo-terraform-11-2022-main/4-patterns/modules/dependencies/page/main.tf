variable "name" {
  
}

resource "local_file" "index" {
  filename = "index.html"
  content = "This is page for ${var.name}"
}

output "index_file" {
  value = local_file.index.filename
}