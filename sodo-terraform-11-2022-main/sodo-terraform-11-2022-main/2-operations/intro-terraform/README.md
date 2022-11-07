# Overview of Terraform core concepts

To observe the typical Terraform code, read the terraform files in this directory. Follow the exercise below and note the most important Terraform commands as well as object types.

Before proceeding, always make sure you have a working AWS profile. 

**This code expects you have set up AWS_PROFILE environment variable to this profile name**.

1. Verify that the command `aws s3 ls` is successful.

## Create a bucket and object using Terraform

1. While in this folder, initialize terraform: 

    ```bash
    cd terraform
    terraform init
    ```

1. If successful, the command should return `Terraform has been successfully initialized!` among various messages.
1. Change the username in `terraform.tfvars` into name of your choice.
1. Run the Terraform code to create necessary objects:

    ```bash
    terraform apply
    ```

1. Correct the code where it is necessary. Apply again.
1. Visit the link given in the outputs.
1. Observe the bucket and the file object in the AWS console.

## Change the object

1. Locate `main.tf` file and change the line 3 to:

    ```tf
    file_name = "./files/swap/keroppi.png"
    ```

1. Run the Terraform apply command to change the object:

    ```bash
    terraform apply
    ```

1. Verify the image has changed by visiting the new link.
1. Observe the results in the "objects" tab of a bucket in AWS console.
1. Delete the object using AWS console. Is the link working? Why? 
1. Run `terraform apply` again. What is the difference in links?

## Clean up

1. Run the Terraform destroy command to clean up everything:

    ```bash
    terraform destroy
    ```

## Discussions

1. Where is the versioning visible in the AWS console?
1. What happens when you delete the versioned object?
1. What objects does the presented Terraform code consists of?
1. What are the primary Terraform commands? 
