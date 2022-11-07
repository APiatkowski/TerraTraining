locals {
  config = yamldecode(file("./config.yaml"))
}

module "networks" {
  source   = "./network"
  for_each = { 
    for vpc in local.config.vpcs : vpc.name => vpc 
  }
  config   = each.value
}

output "networks" {
  value = module.networks
}