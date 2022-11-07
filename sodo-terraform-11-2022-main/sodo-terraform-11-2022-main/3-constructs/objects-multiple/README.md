# Multiple objects

## Maps vs lists

### `for_each` with map

1. In `exercises` folder, create the `multiple-objects` folder and `cd` into it. 
1. Create file `terraform.tfvars`:

    ```tf
    config = {
      project = "test"
      users = {
        mark = {
          type     = "admin"
          ssh_bits = 4096
          aliases = ["mark.h", "luke.s"]
        }
        tom  = {
          type     = "regular"
           ssh_bits = 2048
           aliases = [""]
        }
      }
    }
    ```

1. Create `config` variable declaration in file `variables.tf`.
1. Run `terraform init` to start working with this code in this folder. Remember to always initialize terraform after any major changes in the code.
1. Run `terraform apply` to confirm everything is working.
1. Now, let's alter the locals definition into:

    ```tf
    locals {
      users = var.config.users 
    }
    ```

1. Check the local.users in `terraform console`.
1. Add the multiple resource:

    ```
    resource "tls_private_key" "keys" {
      for_each  = local.users
      algorithm = "RSA"
      rsa_bits  = each.value.ssh_bits
    }
    ```

1. How many resources will be created? What are their full identifiers?

### `for_each` with list

1. Add the local_file multiple resources:

    ```
    resource "local_file" "mark_keys" {
      for_each = local.users.mark.aliases
      content  = tls_private_key.keys["mark"].private_key_openssh
      filename = each.value
    }
    ```

1. Why does the above code fail? What need to be added to use for_each directive?

### `count` with list

1. Add the local_file multiple resources:

    ```
    resource "local_file" "mark_keys" {
      count = length(local.users.mark.aliases)
      content  = tls_private_key.keys["mark"].private_key_openssh
      filename = local.users.mark.aliases[count.index]
    }
    ```

1. How many resources will be created? What are their full identifiers?

## Discuss

How could we create a code that:

* creates a keypair for every user,
* saves the key as the every alias that the given user has?

---
There is more than one solution to this problem. One may involve using modules, others will probably involve loops. We will get to know those methods in next exercises.
