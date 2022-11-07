# Workspaces

Workspaces are separate states of the same infrastructure.

The official documentation can be found [here](https://www.terraform.io/language/state/workspaces).

## Using workspaces

### Default workspace

1. Run terminal in this folder. You will do all your work here.
1. Run `terraform init`.
1. Run `terraform apply` to create the keys. Note the output.
1. Notice and examine the `terraform.tfstate` file.
1. Modify `terraform.tfvars` and change the `bits` to 2048.
1. Run `terraform apply` again. Agree to the changes. Compare the output.
1. Notice and examine the `terraform.tfstate.backup` file.

All this time you were using a `default` workspace, because you did not specify any.

### Workspaces state files

1. Confirm the workspace with `terraform workspace list`.
1. Create new workspace with `terraform workspace new my-test-workspace`.
1. Confirm the workspace with `terraform workspace list`. Notice that terraform changed the workspace when created.
1. Run `terraform apply`. Notice how the `terraform.tfstate.d` has been created. Examine the contents.
1. Create `my-second-test-workspace` and run `terraform apply` again. Examine the `terraform.tfstate.d` contents.

As you can see, every workspace has its own terraform state file.

### Deleting the workspaces

1. Switch to `my-test-workspace` and verify state: 

    ```
    terraform workspace select my-test-workspace
    terraform output
    ```

1. Destroy the contents with `terraform destroy`. Examine the `terraform.state.d/my-test-workspace/terraform.tfstate` file.
1. Switch to `my-second-test-workspace` to verify state: 

    ```
    terraform workspace select my-second-test-workspace
    terraform output
    ```

1. Switch to `default` workspace. Verify the workspaces list with `terraform workspace list`.
1. Delete the `my-test-workspace`: 

    ```
    terraform workspace delete my-test-workspace
    ```

1. Try to delete the `my-second-test-workspace` with `terraform workspace delete my-second-test-workspace`.

Deleting the workspace needs to be forced if any resources exist.

### Environment variable TF_WORKSPACE

1. Set the environment variable `TF_WORKSPACE` to `my-third-workspace` with the command: 

    ```
    export TF_WORKSPACE=my-third-workspace
    ```

1. List the workspaces with `terraform workspace list`. Notice the warning about workspace override.
1. Run the `terraform apply`. Examine the outcome.
1. List the workspaces with `terraform workspace list`. Notice the third workspace has appeared.
1. Switch the workspace to `default` using `terraform workspace select default`. Notice the terraform message about workspace override.
1. Unset the `TF_WORKSPACE` with command:

    ```
    export TF_WORKSPACE=
    ``` 

1. List the workspaces with `terraform workspace list`. Notice the `default` workspace is active, yet the third workspace is ready to be used again.

### Interference

Last part of the exercise will demonstrate the interference if the two workspaces try to manage the same resource.

1. Switch to the `default` workspace
1. Set the 
    
    ```
    username = my-user
    ``` 
    
    in `terraform.tfvars` file. Apply the code.
1. Notice the `my-username` file in the folder.
1. Switch to the `my-third-workspace` workspace. Apply the code.
1. Notice that the `my-username` file contents have changed. The workspace is altering the same resource.
1. Switch back to the `default` workspace and apply the code. Note the change again.
1. Fix the problem and change the `main.tf` file line:

    ```terraform
    filename = "${path.module}/${var.username}"
    ```

    to

    ```
    filename = "${path.module}/${local.username}"
    ```

1. Run `terraform apply` again for both workspaces. Observe the outcome.
1. Analyze the code how the `local.username` is defined.

### Clean up

1. List the workspaces with `terraform workspace list`.
1. Switch to every workspace, run `terraform destroy`.
1. Switch to `default` workspace and delete every other workspace.

NOTE: You cannot delete the `default` workspace.

## Key takeaways

1. You can create, select and destroy as many workspaces as you wish.
1. You can have different states of the same code in those workspaces.
1. You can run different workspaces with different variables.
1. You can select workspaces with `terraform workspace` command or environment variable `TF_WORKSPACE`.
1. Different backend types store workspaces differently.
1. You can force the Terraform to delete the workspace even if infrastructure is not destroyed, but that would mean existing resources will be forgotten.
1. Keep in mind that only the state files are separate in workspaces; if the resources are hardcoded, two workspaces will probably interfere with each other.
1. You can use the workspace's name in the code to remedy the interference.

## Real-world case study: branches as workspaces

The DevOps team has decided that:

* the feature branches will run pipelines on Pull Request event 
* the pipeline steps will be to plan, apply and destroy the infrastructure on a test environment
* every feature branch will be using workspace named the same as the branch name. 

However, there is already a problem in the first attempt on the branch `feature/JIRA-5678-workspaces-added`. Why?

Discuss the problem and the entire approach concept with the group.
