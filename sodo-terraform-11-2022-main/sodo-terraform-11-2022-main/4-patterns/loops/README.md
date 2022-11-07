# Loops

1. Analyze and run with `terraform console` the code in `main.tf` file.
1. Create an output that gives the numbers of current users and current admins.
1. Create a code that creates 4096-bit TLS keys for the admins with their usernames as filenames with a key, and 2048-bit keys for everyone else.

# Challenge

1. Try to create a code that given the `local` definition of the following, sets users departments correctly:

    ```
    locals {
      departments = {
      "HR" = ["ann", "bob"]
      "Finance" = ["tim"]
    }
    ```
    
## Exercises for better practice

### EKS addons

1. Examine the code in the following files. 

    ```
    # root.tf
    # [...]

    module "addons" {
      source = "./eks_addons"

      cluster_name   = aws_eks_cluster.this[0].name
      cluster_addons = {
        coredns = {
          resolve_conflicts = "OVERWRITE"
        }
        kube-proxy = {}
        vpc-cni = {
          resolve_conflicts        = "OVERWRITE"
          service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
        }
      }
    }
    # [...]
    ```


    ```
    # eks_addons/main.tf

    variable "cluster_addons" {
      description = "Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `name`"
      type        = any
      default     = {}
    }

    resource "aws_eks_addon" "this" {
      for_each = { for k, v in var.cluster_addons : k => v if local.create }

      cluster_name = var.cluster_name
      addon_name   = try(each.value.name, each.key)

      addon_version            = lookup(each.value, "addon_version", null)
      resolve_conflicts        = lookup(each.value, "resolve_conflicts", null)
      service_account_role_arn = lookup(each.value, "service_account_role_arn", null)

      depends_on = [
        module.fargate_profile,
        module.eks_managed_node_group,
        module.self_managed_node_group,
      ]

      tags = var.tags
    }
    ```

1. Look for `try` and `lookup` functions in the Terraform documentation.
1. Try to recreate how the cluster_addons variable map is read by the `for_each` function using test project and local variables.

### VPC configuration

1. Look in the `vpc` folder and examin the project.
1. Try to create a real VPC using this code.