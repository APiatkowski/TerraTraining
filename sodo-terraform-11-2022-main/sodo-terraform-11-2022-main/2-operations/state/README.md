# Terraform state file

## Working with state file

The state file is Terraform's memory of the infrastructure. Technically, it is the file that contains everything Terraform knows about the resources represented as code. That is, when applying the code, the *state* is compared to the code, for Terraform to know which elements of the infrastructure **are supposed* to be created (or destroyed). Of course, the result needs to be confronted with reality, which means the real infrastructure needs to be queried for every resource that is supposed to exist according to the statefile.

1. Initialize and apply the code.
1. Examine the terraform.tfstate file. Copy the private keys of alice and bob. Compare with resulting files `alice` and `bob`, respectively.
1. Use Terraform to show the created resources in the state with

    ```
    terraform state list
    ```

1. Delete the file `alice`. Run `terraform apply`. The file should be recreated as it is an infrastructure part.
1. Plan to destroy the alice's key using the `target` as shown below. Notice that two elements are being destroyed.

    ```
    terraform plan -destroy -target tls_private_key.alice
    ```

1. Comment out the code in `main.tf` in lines 11-19 (Bob's keys and file).
1. Run `terraform plan` to verify that those elements are set to be destroyed.
1. Delete the file `bob` and re-run the `terraform plan`.
1. Observe that this time Terraform does not even attempt to delete the file. Instead, you should get the following information:

    ```
    Terraform detected the following changes made outside of Terraform since the last "terraform apply":

      # local_sensitive_file.bob has been deleted
      [...]
    ```

1. Uncomment the code back and reapply the Terraform file to return to original full infrastructure.
1. Comment out Bob's file resource ONLY (lines 16-19).
1. Delete the file `bob`.
1. Run `terraform plan`. Observe the notice about the suggested Terraform state update.
1. Examine the state file. Look for `bob` *local_sensitive_file* resource.
1. Run `terraform apply`. Observe the notice about the suggested Terraform state update.
1. Examine the state file. Look for `bob` *local_sensitive_file* resource.
1. Run `terraform apply` again. Note that the state is altered.
1. Run `terraform destroy` to clean up the project. Uncomment any commented code.

## Altering the statefile

### Remove an item

1. Run the `terraform apply` to create keys and files of `alice` and `bob`.
1. Show the contents of the Terraform state with following command.

    ```
    terraform state list
    ```

1. Remove Bob's file from the state.

    ```
    terraform state rm local_sensitive_file.bob 
    ```

1. Run `terraform apply` and verify the plan as well as the outcome.

    **NOTE: Different providers may present different behaviour when trying to create a resource that is already created. For some resources, that means alignment with existing items, while for others, the *apply* action might fail!**

### Move an item

1. Change every occurence of `bob` in the main.tf file to `stephen`. Observe the outcome of the plan

    ```
    terraform plan
    ```

1. You should observe that the TLS keys are going to be recreated. 
1. Revert the occurences of `stephen` to `bob` again. Run `terraform apply` to verify the state is intact. Your infrastructure should match the configuration.
1. As we do not want to recreate the TLS key resource, but only to change its name, we have two options.

#### Option one - move item in the state

1. Copy the lines 11-19, paste them at the bottom of the file (beginning from line 21) and change every occurence of `bob` to `stephen` in lines 21-29.
1. Use `terraform validate` to check if the code is correct.
1. Use `terraform plan` to observe that Terraform will try to create a new TLS key for Stephen.
1. Move the TLS key state item onto `stephen` resource with following command:

    ```
    terraform state mv tls_private_key.bob tls_private_key.stephen
    ```

1. Create a terraform plan and observe that it is Bob's key that needs to be created; Stephen's is already there.
1. Remove Bob's configuration in the *main.tf* file (lines 11-19) and run `terraform plan` again.
1. Apply and observe the outcome. The local file needs recreation of course, because it uses the username as its filename.

#### Option two - migrate the resource.

1. We now have two keys, Alice's and Stephen's. We will rename Stephen's key to Bob again, this time using **refactoring** technique.
1. Change every occurence of `stephen` in the main.tf file to `bob`.
1. Add the following block in the `migrations.tf` file.

    ```
    moved {
      from = tls_private_key.stephen
      to   = tls_private_key.bob
    }
    ```

1. You should see the outcome as follows. The TLS key is not going to be recreated.

    ```
    # tls_private_key.stephen has moved to tls_private_key.bob
    resource "tls_private_key" "bob" {
        id = "8c227c295fcd3a99a2d5945aebf9a423bbcb5186"
        # (9 unchanged attributes hidden)
    }
    ```
1. The local file needs recreation again, because it uses the username as its filename.

## Summary

1. Which migration method would you use? Discuss with the team.
1. Using all the observations, fill out the following table.

| Case no. | Action | Resource in code | Resource in Terraform state | Resource exists | Outcome |
|---|---|---|---|---|:-:|
| 1 | Apply | Exists | Exists | Exists | No changes required |
| 1 | Apply | Exists | Not exists | Exists | ? |
| 1 | Apply | Exists | Exists | Not exists | ? |
| 1 | Apply | Exists | Not exists | Not exists | ? |
| 1 | Apply | Not exists | Exists | Exists | ? |
| 1 | Apply | Not exists | Exists | Not exists | ? |
| 1 | Apply | Not exists | Not exists | Doesn't matter | Terraform has no knowledge about resource |
| 1 | Destroy | Exists | Exists | Exists | ? |
| 1 | Destroy | Exists | Not exists | Exists | ? |
| 1 | Destroy | Exists | Exists | Not exists | ? |
| 1 | Destroy | Exists | Not exists | Not exists | ? |
| 1 | Destroy | Not exists | Exists | Exists | ? |
| 1 | Destroy | Not exists | Exists | Not exists | ? |
| 1 | Destroy | Not exists | Not exists | Doesn't matter | Terraform has no knowledge about resource |


## Additional links

* [State - Hashicorp documentation](https://www.terraform.io/language/state/purpose)
* [Refactoring - Hashicorp documentation](https://www.terraform.io/language/modules/develop/refactoring)