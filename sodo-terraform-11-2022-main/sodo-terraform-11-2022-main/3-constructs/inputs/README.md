# Inputs and outputs (Terraform variables)

## Variables and their types

Any input to the root project or any submodule (which we will deal later with) is read by variables of different types. Those variables can also come from different sources. Let's compare the differences.

1. Analyze the `variables.tf` and all the `.tfvars` files. 
1. Run `terraform console` to verify the values of:

    ```
    * var.simple_string
    * var.simple_list
    * var.simple_list[0]
    * var.simple_map
    * var.simple_map["my_description"]
    * var.implicit_type
    * type(var.simple_map)
    * type(var.simple_map["my_description"])
    * type(var.implicit_type)
    ```

    NOTE: The command `terraform console` automatically initialized and applied the changes to the project. Also, `type` is a special function which is only available in the `terraform console` command. It can only be used to examine the type of a given value, and should not be used in more complex expressions.

1. In `terraform.tfvars` file, set up `implicit_type` variable to a map:

    ```
    {
      "test1" = 1 
      "test2" = 2 
      "test3" = 3
    }
    ```

1. Run `terraform console` and check the values and type of `implicit_type` variable and its type. It should be `object`. Revert the definition in `terraform.tfvars` to: 

    ```
    implicit_type = "This string is set up by terraform.tfvars"
    ```

    NOTE: The implicit (not defined) type in fact should fail. In older Terraform versions it was only allowed to be string. Now, the implicit conversion allows for loose typing, which is error-prone and should be avoided as a bad practice.

1. Although you can always use `terraform console` to check the values of a specific variable, for complete view we will add *outputs* to all of the variables. Create `outputs.tf` file and add the following:

    ```
    output "simple_string" {
      value = var.simple_string
    }

    output "simple_list" {
      value = var.simple_list
    }

    output "simple_map" {
      value = var.simple_map
    }

    output "implicit_string" {
      value = var.implicit_type
    }
    ```

1. Run `terraform apply` to verify the outputs.

## Variable definitions precedence

As you can see, the `production.auto.tfvars` file is overriding the value of `simple_map` variable. Let's analyze the variables setup methods and their precedence over others.

1. Set up an evironment variable **$TF_VAR_simple_string** with value `"This string is set up by environment variable"`.
1. Run `terraform apply` command.
1. Comment-out the `simple_string` definition from `terraform.tfvars` and re-run `terraform apply`.

    NOTE: Environment variables have LOWER precedence over .tfvars definitions. This is contrary to many popular solutions.

1. Run `terraform apply -var-file exception.tfvars` command. The `simple_string` variable is set up by the file definition.

1. Uncomment the `simple_string` variable definition in `terraform.tfvars`. Re-run the `terraform apply` command. Analyze the results.

1. Compare the outcome of these two commands:

    ```
    terraform apply -var="simple_string=This string is set up in CLI" -var-file exception.tfvars
    terraform apply -var-file exception.tfvars -var="simple_string=This string is set up in CLI"

## Custom validation rules

1. The list `simple_list` has been declared with special validation rules that check if the list has two elements, no more, no less and each one is ended with a dot. Modify the variable and check what happens when these conditions are not met.

1. Try to create your own validation to check if the `simple_map` variable contains `my_description` key.

    HINT: Use Collection Functions (see Reference links)

## Reference links

* Input variables - [https://www.terraform.io/language/values/variables](https://www.terraform.io/language/values/variables)
* Terraform variable types - [https://www.terraform.io/language/expressions/types](https://www.terraform.io/language/expressions/types)
* Terraform Collection Functions - [https://www.terraform.io/language/functions](https://www.terraform.io/language/functions)
* Variable Definition Precedence - [https://www.terraform.io/language/values/variables#variable-definition-precedence](https://www.terraform.io/language/values/variables#variable-definition-precedence)
* Custom Conditions - [https://www.terraform.io/language/expressions/custom-conditions#input-variable-validation](https://www.terraform.io/language/expressions/custom-conditions#input-variable-validation)