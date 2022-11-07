module "aws_static_page" {
  source = "./aws"
  index_source = module.page.index_file
}

module "page" {
  source = "./page"
  name   = module.aws_static_page.bucket_name
}
