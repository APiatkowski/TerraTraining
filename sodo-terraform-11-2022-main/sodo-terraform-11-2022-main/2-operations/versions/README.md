# Terraform versions

## Legacy code behaviours

1. Download terraform executable using following links:

    * Linux - [https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip](https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_linux_amd64.zip)
    * Windows - [https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_windows_amd64.zip](https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_windows_amd64.zip)
    * Mac - [https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_darwin_amd64.zip](https://releases.hashicorp.com/terraform/1.0.11/terraform_1.0.11_darwin_amd64.zip)

    NOTE: this is deliberately NOT the latest version of Terraform.

1. Unzip and run `./terraform version` (or `terraform.exe version` if running on Windows). 

1. You should get the information similar to the following:

    ```
    Terraform v1.0.11
    on linux_amd64

    Your version of Terraform is out of date! The latest version
    is 1.2.1. You can update by downloading from https://www.terraform.io/downloads.html
    ```

1. Execute `./terraform init` and analyze the result.

1. Download and unzip older Terraform executable:

    * Linux: [https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip](https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip)
    * Windows: [https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_windows_amd64.zip](https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_windows_amd64.zip)
    * Mac: [https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_darwin_amd64.zip](https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_darwin_amd64.zip)

1. Execute `./terraform init` again. Notice different outcome.

1. As you can see, even if you may want to use latest versions of Terraform, sometimes legacy code would need to be refactored first.

## Version control

1. In order to utilize the control of Terraform versions that can be used by the project, you can utilize the specific controls. Add the following fragment to the code in `main.tf` file:

    ```
    terraform {
      required_version = "~> 0.13.3"
    }
    ```

1. Execute `./terraform init` again. This command should execute without errors (and one deprecation warning).

1. Unzip the terraform 1.0 version again. Run the `./terraform init` again. Observe the results.

1. What does `~>` constraint symbol mean in the context of `0.13.3`? How would the `~> 0.12` work? Try that constraint with terraform 0.13 and note your observation.

## Automated terraform setup

1. Install `tfswitch` using:

* Linux: [https://github.com/warrensbox/terraform-switcher/releases/download/0.13.1250/terraform-switcher_0.13.1250_linux_amd64.tar.gz](https://github.com/warrensbox/terraform-switcher/releases/download/0.13.1250/terraform-switcher_0.13.1250_linux_amd64.tar.gz)
* Mac: [https://github.com/warrensbox/terraform-switcher/releases/download/0.13.1250/terraform-switcher_0.13.1250_darwin_amd64.tar.gz](https://github.com/warrensbox/terraform-switcher/releases/download/0.13.1250/terraform-switcher_0.13.1250_darwin_amd64.tar.gz)
* Windows: [https://github.com/warrensbox/terraform-switcher/releases/download/0.13.1250/terraform-switcher_0.13.1250_windows_amd64.zip](https://github.com/warrensbox/terraform-switcher/releases/download/0.13.1250/terraform-switcher_0.13.1250_windows_amd64.zip)

1. Run `tfswitch` in the project folder and analyze the outcome. It should look like:

    ```
    Reading required version from terraform file
    Reading required version from constraint: ~> 0.13
    Matched version: 0.15.5
    Installing terraform at /home/maciej/bin
    Creating directory for terraform binary at: /home/maciej/.terraform.versions
    Downloading to: /home/maciej/.terraform.versions
    33043317 bytes downloaded
    Switched terraform to version "0.15.5"
    ```

1. Change the directory to `tfset` and analyze main.tf file contents. 
1. Run `tfswitch` again. Why the installed version is "1.1.5" if the constraint is set to "~> 1.0"?

## Key Takeaways

* **There are different versions of Terraform and the code you will work with may be written for legacy versions**
* In your project you may (and you should) specify Terraform versions allowed to use with the project
* The constraints can be strict or loose
* There are tools for automatic terraform version change
* **It is good practice to always check (and echo) terraform version in any automated pipeline!**

## Related links

* Terraform Downloads -  [https://www.terraform.io/downloads](https://www.terraform.io/downloads)
* TFSwitch Quick Start - [https://tfswitch.warrensbox.com/Quick-Start/](https://tfswitch.warrensbox.com/Quick-Start/)
* TFenv - [https://github.com/tfutils/tfenv#terraform-version-file](https://github.com/tfutils/tfenv#terraform-version-file)
* [Terraform Version Constraints](https://www.terraform.io/language/expressions/version-constraints)
* [Specifying a Required Terraform Version](https://www.terraform.io/language/settings#specifying-a-required-terraform-version)