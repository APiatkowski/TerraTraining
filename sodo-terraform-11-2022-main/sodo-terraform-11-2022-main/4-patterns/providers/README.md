# Providers configuration

The important thing to remember about providers is that the target APIs may change and so can change the resources, their attributes or specifics. Sometimes provider maintainers add functionality or deprecate them. 

That is why it is very important for production-grade code to use the version of the providers as intended by the code's author and to allow for conscious upgrade process.

## Preparation

1. In your `exercises` subfolder, create `providers-mgmt` folder. Change into it.
1. Create empty files:

    ```bash
    echo "" > main.tf
    echo "" > variables.tf
    echo "" > versions.tf
    echo "" > outputs.tf
    ```

1. Remember to set up `AWS_PROFILE` environment variable in the terminal you will run `terraform` commands in.

## Provider version without scope

1. In `main.tf` create the resources with the following code: 

    ```
    # An object that contains a private key, public key, fingerprints, etc.
    resource "tls_private_key" "key" {  
      algorithm = "RSA"
      rsa_bits  = 4096
    }

    # Just a random string in memory
    resource "random_string" "random" {
      length = 8
    }

    # This will exist in AWS account when applied. AWS key is a public key stored in the cloud.
    resource "aws_s3_bucket" "bucket" {
      bucket   = "my-username-test-bucket"
      acl = "private"
    }

    ```

1. Run `terraform init`. You should receive the message similar as below:

    ```
    Initializing provider plugins...
    - Finding latest version of hashicorp/random...
    - Finding latest version of hashicorp/tls...
    - Finding latest version of hashicorp/aws...
    - Installing hashicorp/random v3.3.2...
    - Installed hashicorp/random v3.3.2 (signed by HashiCorp)
    - Installing hashicorp/tls v3.4.0...
    - Installed hashicorp/tls v3.4.0 (signed by HashiCorp)
    - Installing hashicorp/aws v4.17.1...
    - Installed hashicorp/aws v4.17.1 (signed by HashiCorp)

    Terraform has created a lock file .terraform.lock.hcl to record the provider
    selections it made above. Include this file in your version control repository
    so that Terraform can guarantee to make the same selections by default when
    you run "terraform init" in the future.
    ```

1. Analyze the contents of `terraform.lock.hcl`. This is so-called [dependency lock file](https://www.terraform.io/docs/language/dependency-lock.html).
1. As you see, Terraform downloaded and used the latest provider version. 

    **NOTE: Using latest version may lead to unexpected infrastructure changes or unsuccessful applies in the future, when the same code is going to be used but with another (later) provider version.**

1. Run `terraform validate` to see the deprecation warning.

    ```
    ╷
    │ Warning: Argument is deprecated
    ```

As you can see in the message, argument is deprecated - the code was written for the older version of the `aws` provider. It will still work or it may not if your provider's version is not allowing such a syntax anymore.

---
REMEMBER: By specifying carefully scoped provider versions and using the dependency lock file, you can ensure Terraform is using the correct provider version so your configuration is applied consistently.

---

## Provider versions scope

1. Put the following code into `versions.tf` file, trying to set up versions you got on the previous step:

    ```
    terraform {
      required_version = ">= 1.0.0"
      required_providers {
        random = {
          source  = "hashicorp/random"
          version = "~> 3.2.0"
        }
        aws = {
          source  = "hashicorp/aws"
          version = "~> 4.17.1"
        }
        tls = {
          source  = "hashicorp/tls"
          version = "~> 3.4.0"
        }
      }
    }
    ```

1. Run `terraform init` again. The behaviour should be identical - you did not change any versions, after all.
1. Change the `aws` version constraint to `~> 3.0` and run `terraform init` again.
1. You should get the information about locked version. This is `terraform.lock.hcl` file in effect.
1. While there is a special flag for `terraform init`, let's first test what would happen if the `terraform.lock.hcl` wasn't there - delete the file and try `terraform init` again.
1. Terraform should download the provider without complaints. Note that this may not always be desired behaviour! 
1. What version has been downloaded? Why not `3.0.X`?
1. Change the `aws` provider version to `~> 3.69.0`.
1. This time, use `terraform init -upgrade` command. Technically we have downgraded the provider.
1. Use `terraform validate` command to see that the code is compliant with that version.

## Version scope within modules

1. Create `s3-file` folder and in this folder, files `main.tf`, `variables.tf` and `versions.tf`.
1. In `s3-file/main.tf` put the following code:

    ```
    resource "aws_s3_object" "name" {
      bucket = var.bucket
      content = var.content
      name = var.name
    }
    ```

1. In `s3-file/variables.tf` put the following code:

    ```
    variable "content" {
      type = string  
    }

    variable "name" {
      type = string
    }

    variable "bucket" {
      type = string
    }
    ```

1. In `s3-file/versions.tf` put the following code:

    ```
    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = ">= 4.0"
        }
      }
    }
    ```

1. In root folder, add the following code to `main.tf`:

    ```
    module "s3_file" {
      source  = "./s3-file"
      content = tls_private_key.key.public_key_openssh
      name    = "public.key"
      bucket  = aws_s3_bucket.bucket.id
    }
    ```

1. Run `terraform init -upgrade`. This command will fail. Analyze the reason.

--
As you can see, there is no way to run the project's code if different parts have requirements that deny each other!

You need to refactor the root project, or the module code.

## Challenge

1. Set everywhere (root folder and module's `versions.tf`) back to the latest version of `aws` provider and refactor the code to eliminate deprecations.
1. Put everything into one module called `s3-keys`:
    1. The bucket should be created if not given in variables
    2. The rsa_bits should be set up as an argument or be `4096`.
    3. The key name should be set up as an argument or be `public.key`.

## Key takeaways

1. You should set up provider version **everytime**.
1. You should commit `.terraform.lock.hcl` file so no-one uses different versions unknowingly.
1. You can change version by adding `-upgrade` flag to `terraform init`.

---
Best practice according to Hashicorp is to use *minimal* (`>=`) provider versions constraints in modules, and *scoped* (`~>`) provider versions in project root. I would however recommend that you always use **scoped versioning**:

* set to **major** in modules (`~> X.Y`, where X.Y.Z is Major.Minor.Patch) 
* set to **minor** in root (`~> X.Y.Z`, where X.Y.Z is Major.Minor.Patch)

That way you are always sure what provider is used, and the decision of an upgrade is conscious, because it has to be first made in code.
