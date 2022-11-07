# Import case study

In this exercise, you will import a DynamoDB table. We will create a table in AWS account and we will import it to Terraform code so we can start managing this resource only using Terraform code.

## Create the DynamoDB table in AWS console

1. In your AWS Console, navigate to **DynamoDB**.
1. Note down the region you are operating in.
1. From menu on the left, select **Tables**.
1. On the right, select **Create table**.
1. Use `mytable` as a table name.
1. Use `my_part (String)` as a Partition key.
1. Use `my_sort (String)` as a Sort key.
1. Leave the rest as default settings and create a table.

## Import with code from scratch

1. Check the [Terraform DynamoDB resource documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) on how to import a dynamodb table.
1. Create a folder for a new project and change the location into it.
1. Create `providers.tf` with the `aws` provider configuration using region where you created DynamoDB table in.
1. Create `main.tf` file and insert the following code:

    ```
    data "aws_dynamodb_table" "mine" {
      name = "mytable"
    }
    ```

1. Initialize with `terraform init` and apply with `terraform apply`.
1. Review the data object using `terraform console`.
1. Create the code for the resource `aws_dynamodb_table` `mytable` using the [documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table). It should look like this:

    ```
    resource "aws_dynamodb_table" "mine" {
        name     = "mytable"
        hash_key = ...
        [...]
    }
    ```

1. When you think you are ready, import the resource as the documentation indicates:

    ```
    terraform import aws_dynamodb_table.mine mytable
    ```

1. You should receive the message similar to:

    ```
    aws_dynamodb_table.mytable: Importing from ID "mytable"...
    aws_dynamodb_table.mytable: Import prepared!
        Prepared aws_dynamodb_table for import
    aws_dynamodb_table.mytable: Refreshing state... [id=mytable]

        Import successful!

    The resources that were imported are shown above. These resources are now in
    your Terraform state and will henceforth be managed by Terraform.
    ```

1. Run `terraform plan`. You may receive complaints about the required argument not being set. Fill out the required arguments and try again.
1. **If the terraform plan shows required changes, alter the code until no changes are required**.
1. Congratulations! You have imported the complex resource as a code. You can run `terraform apply` and no action should be executed.

---
Remove the resource from the `main.tf` code and delete `terraform.tfstate`. We will start again and use another method to import the resource.


## Import using datasource

1. Insert the following code into `main.tf` file:

    ```
    data "aws_dynamodb_table" "mytable" {
      name = "mytable"
    }
    ```

1. Initialize with `terraform init` and apply with `terraform apply`.
1. Review the data object using `terraform console`.

    ```
    terraform console
    data.aws_dynamodb_table.mytable
    ```
    
1. Create the code for the resource `aws_dynamodb_table` `mytable` using the fields from a data source. It should look like this:

    ```
    resource "aws_dynamodb_table" "my_table" {
        name     = "mytable"
        hash_key = # the same fields as in data source ...
        [...]
    }
    ```

1. When you are ready, import the resource as the documentation indicates.
1. You should receive the message similar to:

    ```
    aws_dynamodb_table.mytable: Importing from ID "mytable"...
    aws_dynamodb_table.mytable: Import prepared!
        Prepared aws_dynamodb_table for import
    aws_dynamodb_table.mytable: Refreshing state... [id=mytable]

        Import successful!

    The resources that were imported are shown above. These resources are now in
    your Terraform state and will henceforth be managed by Terraform.

1. Run `terraform plan`. You should not receive complaints about argument not being set and the plan should apply no changes.

## Key takeaways

1. You can write the code yourself from scratch and try to import the resource (method known as **cherry-picking**)
1. You can also use data to verify the attributes and copy them (method known as **current-state**)
1. Don't be afraid to iterate through the process!

Reference: [https://learn.hashicorp.com/tutorials/terraform/state-import?in=terraform/state](https://learn.hashicorp.com/tutorials/terraform/state-import?in=terraform/state)