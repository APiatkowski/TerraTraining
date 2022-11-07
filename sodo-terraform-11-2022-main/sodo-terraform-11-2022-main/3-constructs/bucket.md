# Exercise 2. Bucket

1. Create a project that uses Terraform to:
    1. Create a random suffix
    1. Generate an SSH key
    1. Create a PRIVATE S3 bucket with name `<your_profile_name>-keys-<random_suffix>`
    1. Put your private key as an object `<your_profile_name>-key` into the S3 bucket.

### Useful links:

* [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
* [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object)
* [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)

## Optional challenge: 

1. Analyze the code with `terrascan` tool. Discuss remedies for risks.