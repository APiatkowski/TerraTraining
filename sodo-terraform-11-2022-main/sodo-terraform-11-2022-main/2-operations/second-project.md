# Second project

## Root directory

Create an empty directory called `second-project` and change the location into it.

```bash
mkdir second-project && cd second-project
```

## Terraform files

Create the following empty files in the `root` directory:

* `main.tf`
* `variables.tf` 
* `outputs.tf`
* `providers.tf`
* `versions.tf`

## Providers

1. Create the terraform configuration in the `versions` file:

    ```tf
    terraform {
      required_version = ">= 1.0.0"
    }
    ```

1. Add the `aws` provider configuration in the `providers` file:

    ```tf
    provider "aws" {
      region  = "eu-central-1"
      profile = "sodo"
    }
    ```

1. Initialize the project with `terraform init` command. Observe the "aws" provider version.
1. Add the version configuration to the `terraform` configuration block:

    ```tf
    terraform {
    # [...]

      required_providers {
        aws = {
          version = "~> 4.X.0"        # Input latest observed version here 
          source  = "hashicorp/aws"
        }
      }

    }
    ```

## Resources

1. Create three `tls_private_key` resources in the `main.tf` file.
1. Create three `aws_key_pair` objects corresponding to the private keys, also in the `main.tf` file.

## Outputs

1. Create outputs for every private key (`private_key_pem` attribute) in the `outputs.tf` file.

## Variables

1. Add the following to the `variables.tf` file:

    ```tf
    variable "region" {
      type        = string
      default     = "eu-central-1"
      description = "AWS region"
    }

    variable "profile" {
      type        = string
      default     = "sodo"
      description = "AWS profile"
    }
    ```

    Don't forget to save the file.

1. Change the provider configuration to:

    ```tf
    provider "aws" {
      region  = var.region
      profile = var.profile
    }
    ```

1. Reapply the project with `terraform apply`. Result should be successful.

## Challenge

1. Change the AWS key names so that they are prefixed with `environment` variable like this: 

    ```tf
    "${var.environment}-this-key-name"
    ```

    You will need to create a variable declaration and definition for "environment", too.
