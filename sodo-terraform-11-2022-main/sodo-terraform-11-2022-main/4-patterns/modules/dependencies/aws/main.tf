variable "index_source" {
  
}

resource "random_pet" "name" {
  length = 2
}

resource "aws_s3_bucket" "example" {
  bucket = "${random_pet.name.id}.example.com"
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.example.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.example.bucket
  key = "index.html"
  source = var.index_source
}