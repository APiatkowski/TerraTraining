# First project

## Root directory

Create an empty directory called `first-project` and change the location into it.

```bash
mkdir first-project && cd first-project
```

This is called the project's `root` directory. Every command you run should be done in this `root` directory. If something goes wrong, check first if you are in the right location.

## Terraform files

Create a `start.tf` file in the `root` directory. You could name the file whatever you want, as long as it has `.tf` extension. When you run `terraform` commands, all of the `.tf` files in the project's folder are combined into one, so it really does not matter how are they organized and named.

```bash
echo "# start.tf" > start.tf
```

## Terraform init

Initialize the project with `terraform init` command.

```bash
terraform init

Initializing the backend...

Initializing provider plugins...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

### Add Terraform resource

Use your favourite editor to edit the `start.tf` file and input the definition of the first resource:

```tf
# start.tf

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits = 2048
}
```

Run terraform init again to see the result:

```bash
terraform init


Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/tls...
- Installing hashicorp/tls v3.1.0...
- Installed hashicorp/tls v3.1.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Analyze the files that have appeared in the root folder:

* `.terraform` folder
* `.terraform.lock.hcl` file

### Add constraints

Add the following to the `start.tf` file:

```tf
terraform {
  required_version = "~> 1.0.5"
  required_providers {
    tls = {
      version = "~> 3.0.0"
      source  = "hashicorp/tls"
    }
  }
}
```

Run `terraform init` again and observe the result. 

* What is the way to force downgrade the `tls` library? 
* Does it work?

## Terraform apply

1. Run `terraform apply` in the project root folder. Answer "yes" when asked.
1. Examine the outcome.
1. Examine the `terraform.tfstate` file.
1. Run `terraform apply` again.
1. Modify the `rsa_bits` to 4096.
1. Run `terraform apply` again.
1. Examine the `terraform.tfstate` and `terraform.tfstate.backup` files.
1. Run `terraform apply` again.

## Terraform destroy

1. Run `terraform destroy` in the project root folder. Answer "yes" when asked.
1. Examine the outcome.
1. Examine the `terraform.tfstate` file.
1. Run `terraform destroy` again.
