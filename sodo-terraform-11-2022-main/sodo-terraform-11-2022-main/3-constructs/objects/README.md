# Object complex type

## Maps vs objects

1. In `exercises` folder, create the `objects` folder and `cd` into it. 
1. Create file `terraform.tfvars`:

    ```
    config = {
      project = "test"
    }
    ```

1. Create file `main.tf`:

    ```tf
    variable "config" {
      type    = map(any)
      default = {}
    }
    ```

1. Run `terraform init` to start working with this code in this folder. Remember to always initialize terraform after any major changes in the code.

1. Run `terraform apply` to confirm everything is working.

1. Add more structure to `config` definition in `terraform.tfvars`:

    ```
    config = {
      project = "test"
      users = {
        mark = "admin"
        tom  = "regular"
      }
    }
    ```

1. Run `terraform validate`.

    NOTE: Terraform won't allow above code. Discuss why.

1. Change the variable declaration and validate again:

    ```tf
    variable "config" {
      type = object({
        project = string
        users = map(string)
      })
      default = {}
    }
    ```

1. What is the reason for `terraform validate` command to fail again?
1. Set up the default to `null`. Is it allowed?
1. Add the following `local` definition:

    ```tf
    locals {
      test = var.config == null ? {} : {
        name        = lookup(var.config, "name", null)
        description = lookup(var.config, "description", null)
      }
    }
    ```

1. Use `terraform console` command and type to inspect the following:

    ```
    var.config
    local.test
    ```

    What is the type of the `local.test`?

1. Try to add the `local` definition of `test2` that also has the `users` field read.

    ```tf
    locals {
    # [...]
      test2 = var.config == null ? {} : {
        project     = lookup(var.config, "project", "default_project_name")
        description = lookup(var.config, "description", null)
        users       = lookup(var.config, "users", null)
      }
    }
    ```

1. What is the problem? 
1. Alter the definition of the `test2` local as below. Pay attention where the `null` value is set up.

    ```tf
    locals {
    # [...]
      test2 = var.config == null ? null : {
        project     = lookup(var.config, "project", "default_project_name")
        description = lookup(var.config, "description", null)
        users       = lookup(var.config, "users", null)
      }
    }
    ```

1. Validate the code and use `terraform console` to compare:

    ```
    var.test
    local.test
    local.test2
    ```

1. What is the type of `local.test2` ?

    **NOTE AND REMEMBER: The local type is dynamically inherited and may depend on previous implicit conversions in your code.** However, implicit is not illicit ;)


## Complex object decomposition

Let's decompose the config variable using locals. 

1. Rewrite the terraform.tfvars

    ```tf
    config = {
      project = "test"
      users = {
        mark = {
          type     = "admin"
          ssh_bits = 4096
        }
        tom  = {
          type     = "regular"
           ssh_bits = 2048
        }
      }
    }
    ```

    NOTE: The definition above will require one change in variable declaration to validate.

1. Now, let's alter the locals definition into:

    ```tf
    locals {
      users = var.config.users 
    }
    ```

1. Check the local.users in `terraform console`.
1. Add the resource:

    ```
    resource "tls_private_key" "mark" {
      algorithm = "RSA"
      rsa_bits  = local.users.mark.ssh_bits
    }
    resource "tls_private_key" "tom" {
      algorithm = "RSA"
      rsa_bits  = local.users["tom"].ssh_bits
    }
    ```

---
Notice the array-like `users["tom"]` association in tom's resource. Semantically this notation is the same as `users.mark` in this case. 

It is a good practice to use dotted notation when the sub-object is already known (such as attributes of a module or a resource) and the array notation when the attribute is dynamically get from a variable or data object read from external location to indicate it may not always be set up.

---

Of course, you should not create those resources in a manner as above, because each time the users map is going to be changed, such node would need rewrite.

We are going to explore this further in the next module.

## Reference links

* Local Variables - [https://www.terraform.io/language/values/locals](https://www.terraform.io/language/values/locals)
* Complex Types - [https://www.terraform.io/language/expressions/type-constraints#complex-type-literals](https://www.terraform.io/language/expressions/type-constraints#complex-type-literals)