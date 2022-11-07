locals {
  bucket_name = "this-is-exclusive-test-bucket-for-${var.username}"
  file_name   = "./files/keroppi.png"
}

resource "aws_s3_bucket" "bucket" {
  bucket        = local.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "keroppi.png"
  source = local.file_name
  etag   = filemd5(local.file_name)
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "static_site" {
  bucket = aws_s3_bucket.bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

output "link" {
  value = "http://${aws_s3_bucket_website_configuration.static_site.website_endpoint}/keroppi.png"
}