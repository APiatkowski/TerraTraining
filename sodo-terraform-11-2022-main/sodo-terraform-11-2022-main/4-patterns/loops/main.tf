# Single user

locals {
  ann = {
    username   = "ann"
    department = "HR"
    admin      = "false"
  }
  user_file = templatefile("userinfo.tftpl", local.ann)
}

# Multiple users, defined explicitly

locals {
  users = {
    ann = {
      department = "HR"
      is_admin   = true
    }
    joe = {
      department = "HR"
      is_admin   = false
    }
    tim = {
      department = "HR"
      is_admin   = false
    }
  }

  users_file = templatefile("usersinfo.tftpl", { users = local.users })
}

# Multiple users, defined by loop

locals {
  usernames = ["ann", "joe", "tim"]
  admins    = ["ann"]
  departments = {
  "HR" = ["ann", "bob"]
  "Finance" = ["tim"]
  }

  users_generated = { for user in local.usernames :
    user => {
      department = "HR"
      is_admin   = contains(local.admins, user)
    }
  }

  users_generated_with_depts = {
    for user in local.usernames : 
    user =>
      {
        is_admin   = contains(local.admins, user)
        department = element(lookup(transpose(local.departments), user, ["None"]), 0)
      }
  }  

  users_generated_file = templatefile("usersinfo.tftpl", { users = local.users_generated })
  }

# Filter example

locals {

  admins_generated = { for user in local.usernames :
    user => {
      department = "HR"
    } if contains(local.admins, user) == true
  }
}

# Conditional example

# resource "tls_private_key" "keys" {
#   count = var.is_admin == true ? 1 : 0
#   algorithm = "RSA"
# }

# output "output_of_a_possibly_nonexistent_object" {
#   ## YE OLDE WAY
#   ## value = coalesce(tls_private_key.keys.public_key_openssh, "")
#   value = var.is_admin == false ? "" : tls_private_key.keys.public_key_openssh
# }

output "number_of_users" {
  value = "Users: ${join(",", keys(local.users))}"
}

resource "tls_private_key" "keys" {
  for_each  = local.users
  algorithm = "RSA"
  rsa_bits  = each.value.is_admin == true ? 4096 : 2048
}

resource "local_file" "private" {
  for_each = tls_private_key.keys
  filename = each.key
  content  = each.value.private_key_openssh
}