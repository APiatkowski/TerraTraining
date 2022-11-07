# Remote modules

Any module in your code can be installed not only from local directory, but also from numerous locations:

* Terraform Registry
* Git Registry
  * specifically GitHub
  * specifically BitBucket
* HTTP URL
* S3 / GCS buckets

Such sources lead to a **package** which could be:

* version control repository
* archive file (e.g. .zip)

The access to those sources depends on the access level available to the terminal context in which `terraform` is run. For example, when using git, Terraform installs modules from Git repositories by running `git clone` command, and so it will respect any local Git configuration set on your system, including credentials. 

## Prerequisites

1. In the `exercises` folder, create a directory `remote-modules`. This is going to be the **root** directory.

## HTTPS public source

1. Create a new public repository (project) in your GitLab titled `htpasswd-entry`.
1. Clone the repository in your `exercises` folder, create the `htpasswd-entry` folder and put `main.tf`, `versions.tf`, `variables.tf` files into it.
1. Using the information and examples from [https://github.com/loafoe/terraform-provider-htpasswd](https://github.com/loafoe/terraform-provider-htpasswd) create a code that:
  1. Creates a password and a salt
  1. Creates a `.htpasswd` entry, with given username
  1. Returns this entry line as `entry`.
  1. Don't forget the provider versioning definition.
  1. If you struggle to finish, check the example in `entry` folder here.
1. Test the module locally using the following code in `remote-modules` project:

    ```
    module "entry" {
      source   = "../htpasswd-entry"
      username = "joe"
    }
    ```

1. Commit when finished. Now you can use the module in the root folder with the code **similar to**:

    ```
    module "entry" {
      source   = "git::https://gitlab.com/train-terraform/htpasswd-entry"
      username = "joe"
    }
    ```

## Git source accessed using SSH

1. Create a new private repository (project) in your GitLab called `public-modules`
1. To use SSH as an access method, you need to put your SSH keys into GitLab repository:
  1. Create an SSH key.
  1. Put it as a deploy key under `public-modules` settings.
  1. If you struggle with this task, check "Sources" section below.
1. Git clone the `public-modules` repository in your `exercises` folder.
1. In `public-modules`, create `htpasswd-file` folder
1. Put the following code into corresponding `.tf` files into `public-modules/htpasswd-file`:

    ```
    variable "users" {
      type = list
    }

    locals {
      entriesmap   = { for k, entry in module.entries : k => entry.entry }
      file_content = join("/n", values(local.entriesmap))
    }

    module "entries" {
      source   = "git::https://gitlab.com/train-terraform/htpasswd-entry" # put your repository address here
      for_each = toset(var.users)
      username = each.value
    }

    output "content" {
      value = local.file_content
    }
    ```

1. Go back to `remote-modules` folder in your `exercises`.
1. Test the code using local source definition:

    ```
    module "htpasswd_file" {
      source = "../public-modules/htpasswd-file"
      users  = ["joe", "ann", "bob"]
    }

    resource "local_file" {
      content  = module.htpasswd_file.content
      filename = "./.htpasswd"
    }
    ```

1. When successful, commit the changes. Now you should be able to use the source **similar to the following**:

    ```
    source = "git::ssh://git@gitlab.com:public-modules.git//htpasswd-file"
    ```

  Notice the double slash `//` after the repository name.

1. If you have trouble accessing the repository by SSH, review your OS's setting on the default SSH keys (or use Pageant in Windows and `ssh-agent` in Linux).

## Versioning modules with source control version

We did the entries but we don't have real passwords and their users! We will fix it in new version.

1. Go to `htpasswd-entry` repository folder.
1. Create a branch `add-password`.
1. Add the output of a user's password as `password`.
1. Commit and push the branch to the origin.
1. Go to `public-modules/htpasswd-file`.
1. Create a branch `add-passwords`.
1. Modify the module definition:

    ```
    module "entries" {
      source   = "git::https://gitlab.com/train-terraform/htpasswd-entry?ref=add-password" # notice the 'ref' argument
      for_each = toset(var.users)
      username = each.value
    }
    ```

1. Add new output definition:

    ```
    output "users_passwords" {
      value = { for k, entry in module.entries : k => entry.password }
    }
    ```

1. Test and commit the solution.
1. Now you should be able to use the source **similar to the following**:

    ```
    source = "git::ssh://git@gitlab.com:public-modules.git//htpasswd-file?ref=add-passwords"
    ```

Sources:

* [https://docs.gitlab.com/ee/user/ssh.html](https://docs.gitlab.com/ee/user/ssh.html)
* [https://docs.gitlab.com/ee/user/project/deploy_keys/](https://docs.gitlab.com/ee/user/project/deploy_keys/)
* [https://docs.gitlab.com/ee/ci/ssh_keys/](https://docs.gitlab.com/ee/ci/ssh_keys/)
* [Subdirectories in packages](https://www.terraform.io/language/modules/sources#modules-in-package-sub-directories)
