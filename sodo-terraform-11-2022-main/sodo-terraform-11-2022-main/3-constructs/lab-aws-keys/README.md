# AWS Keys Lab

In this exercise, we will create AWS key pairs for our users. In AWS, you don't put a private-public key pair - only public keys are stored. Therefore, you will create the TLS key pairs locally and then create corresponding public keys in AWS for your users to use them.

1. In `exercises` folder, create the `aws-keys-lab` folder and `cd` into it. 

```bash
mkdir aws-keys-lab && cd aws-keys-lab
```

## Terraform files

Create the following empty files in the root directory:

* `main.tf`
* `variables.tf` 
* `outputs.tf`
* `providers.tf`

## Provider setup

1. Set up terraform required version in the `providers` file to be at least `1.2`.
1. Refer to [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) to add the `aws` provider configuration in the `providers` file. You will be provided with AWS keys or you can use your own.
1. Initialize the project with `terraform init` command. Observe the "aws" provider version.
1. Add the version configuration to the `terraform` configuration block:

    ```tf
    terraform {
    # [...]

      required_providers {
        aws = {
          version = "~> 3.57.0"        # Input latest observed version here 
          source  = "hashicorp/aws"
        }
      }

    }
    ```

## Resources setup

The tls_private key definition can be found [here](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key).

The AWS public key resource definition can be found [here](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair).

1. Create three `tls_private_key` resources in the `main.tf` file.
1. Create three `aws_key_pair` objects corresponding to the private keys, also in the `main.tf` file.

## Outputs

1. Create outputs for every private key (`private_key_pem` attribute) in the `outputs.tf` file.

## Variables

1. Add the following to the `variables.tf` file:

    ```tf
    variable "region" {
      type        = string
      default     = "eu-west-1"
      description = "AWS region"
    }
    ```

    Don't forget to save the file.

1. Use the **var.region** in provider configuration.

## Challenge

1. Set the AWS key names so that they are prefixed with `environment` variable and the username which the key has been created for. 

    HINT: You will need to use map of users and create a variable declaration and definition for "environment", too.
