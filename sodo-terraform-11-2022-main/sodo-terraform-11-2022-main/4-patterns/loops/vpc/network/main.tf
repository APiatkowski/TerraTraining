/***********************
*
* This is a placeholder
*
* Put a real code here
*
************************/

variable "config" {
  type = object(
    {
      name   = string
      cidr   = string
      region = string
      azs    = number
      subnets = list(
        object({
          name  = string
          type  = string
          cidrs = list(string)
        })
      )
    }
  )
}

locals {
  this = var.config
  private_subnets_map = {
    for subnet in local.this.subnets :
    "${local.this.name}-${subnet.name}" => subnet.cidrs
    if subnet.type == "private"
  }
  subnets_list = flatten([
    for subnet in local.this.subnets : [
      for i, cidr in subnet.cidrs : {
        network = local.this.name
        subnet  = subnet.name
        type    = subnet.type
        region  = local.this.region
        name    = "${local.this.name}-${subnet.name}-${i + 1}"
        cidr    = cidr
      }
    ]
  ])
  private_subnets_maps = {
    for subnet in toset(local.subnets_list) :
    subnet.name => subnet
    if subnet.type == "private"
  }
}

module "subnets" {
  source   = "./subnet"
  for_each = local.private_subnets_maps
  config   = each.value
}

output "name" {
  value = local.this.name
}

output "subnets" {
  value = module.subnets
}

# SIMPLER OUTPUTS

# output "private_subnets_groups" {
#   value = [
#     for subnet in local.this.subnets : "${local.this.name}-${subnet.name}" if subnet.type == "private"
#   ]
# }

# output "private_subnets_maps" {
#   value = {
#     for subnet in local.private_subnets_maps : 
#       subnet.name => subnet
#     if subnet.type == "private" 
#   }
# }
