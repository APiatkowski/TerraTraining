# Documenting code

Terraform is meant to be self-documenting, which means it should be self-explanatory.

However, as it is often in the programming world, when analyzing the code which was written by somebody else, you will find that there are techniques that are necessary for the IaC to be understandable.

## Comments

1. Analyze the code below. Try to explain the sense of the code.

    ```t
    locals {
      repository_tag = regexall("refs/heads/([0-9a-zA-Z-.]*)", var.source_branch)
      tag_name       = length(local.repository_tag) > 0 ? lower(local.repository_tag[0][0]) : "untagged"
    }
    ```

1. Compare the code to the fragment below.

    ```tf
    locals {
      repository_tag = regexall("refs/heads/([0-9a-zA-Z-.]*)", var.source_branch)
      # If the pattern has one or more unnamed capture groups (), the regexall result is a list of lists!
      # So check if you can pull SOMETHING out a branch name or you need to fallback to "untagged"
      tag_name = length(local.repository_tag) > 0 ? lower(local.repository_tag[0][0]) : "untagged"
    }
    ```

Places where comments are very important to put to:

* special cases or expected values (where do they come from)
* complex functions and syntax
* reasons for dependency (`depends_on`)or lifecycle (`ignore_changes`) metaarguments

## Descriptions

You can put descriptions in both `variables` as in `outputs`. Consider them as documentation for all future users of the code. The variable description also is shown when the CLI is used without variable definition.

1. Create the project in temporary folder and put the following into `main.tf`:

    ```tf
    variable "username" {
      type = string
      description = "Vault User Name"
    }

    output "user_id" {
      value       = "vault-${replace(lower(trim(var.username, " ?!@$")), " ", "-")}"
      description = "Username slug in the system"
    }
    ```

1. Initialize and apply. Observe as the variable description is given at the prompt:

    ```
    var.username
      Vault User Name

      Enter a value:
    ```

---

    NOTE: You should **always set up description for variables**. It is a good practice and should be done already when creating a variable. If you omit the description, you are already creating a technological debt.

---

## Automatic documentation

There are ways to leverage descriptions and comments to create a documentation automatically.

1. Install [terraform-docs](https://terraform-docs.io/user-guide/installation/) using the installation guide.
1. Go to the `tls-keys-module` folder and analyze the code.
1. Run the following command:

    ```
    terraform-docs . > README.md
    ```

1. Open the created README.md.
1. Analyze the config file for terraform-docs in the `.config` folder (this file is read automatically because it is in the location that terraform-docs expects it to be). Notice the `header-from` and `content` settings. Compare with the README you created.

## Discuss

You can put the command for automatically creating the documentation into CI/CD or even use that as pre-commit. What would you set up in your CI/CD? 